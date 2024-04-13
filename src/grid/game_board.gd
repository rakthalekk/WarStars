## Represents and manages the game board. Stores references to entities that are in each cell and
## tells whether cells are occupied or not.
## Units can only move around the grid one at a time.
class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

## Resource of type Grid.
@export var grid: Resource

## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}
var _active_unit: Unit
var _walkable_cells := []
var _origin_cell = Vector2.ZERO

var unit_moved := false
var attack_targets: Array[Unit]

var attacking = false

@onready var _unit_overlay: UnitOverlay = $UnitOverlay
@onready var _unit_path: UnitPath = $UnitPath


func _ready() -> void:
	_reinitialize()


func _process(delta):
	if _active_unit and (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("right_click")):
		if attacking:
			highlight_targets(false)
			$ActionWindow.show()
			attacking = false
		elif !_active_unit._is_walking:
			_on_cancel_pressed()


func _get_configuration_warning() -> String:
	var warning := ""
	if not grid:
		warning = "You need a Grid resource for this node to work."
	return warning


## Returns `true` if the cell is occupied by a unit.
func is_occupied(cell: Vector2) -> bool:
	return _units.has(cell)


## Returns an array of cells a given unit can walk using the flood fill algorithm.
func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.cell, unit.move_range)


## Clears, and refills the `_units` dictionary with game objects that are on the board.
func _reinitialize() -> void:
	$ActionWindow.hide()
	_units.clear()

	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit


## Returns an array with all the coordinates of walkable cells based on the `max_distance`.
func _flood_fill(cell: Vector2, max_distance: int, attack_range = false) -> Array:
	var array := []
	var stack := [cell]
	while not stack.size() == 0:
		var current = stack.pop_back()
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue

		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue

		array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if !attack_range && is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			# Minor optimization: If this neighbor is already queued
			#	to be checked, we don't need to queue it again
			if coordinates in stack:
				continue

			stack.append(coordinates)
	return array


## Updates the _units dictionary with the target position for the unit and asks the _active_unit to walk to it.
func _move_active_unit(new_cell: Vector2) -> void:
	_origin_cell = _active_unit.cell
	
	if new_cell == _active_unit.cell:
		set_unit_moved(true)
		_popup_action_window(_active_unit.position)
	
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	# warning-ignore:return_value_discarded
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	set_unit_moved(true)
	_active_unit.walk_along(_unit_path.current_path)
	await _active_unit.walk_finished
	_popup_action_window(_active_unit.position)


## Selects the unit in the `cell` if there's one there.
## Sets it as the `_active_unit` and draws its walkable cells and interactive move path. 
func _select_unit(cell: Vector2) -> void:
	if not _units.has(cell):
		return

	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)


## Deselects the active unit, clearing the cells overlay and interactive path drawing.
func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	set_unit_moved(false)


func set_unit_moved(moved) -> void:
	unit_moved = moved
	if moved:
		_unit_path.stop()


## Clears the reference to the _active_unit and the corresponding walkable cells.
func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()


func _popup_action_window(pos: Vector2):
	find_attack_targets()
	
	if attack_targets.size() > 0:
		$ActionWindow/VBoxContainer/Attack.show()
	else:
		$ActionWindow/VBoxContainer/Attack.hide()
	
	$ActionWindow.position = pos + Vector2(20, -40)
	$ActionWindow.visible = true


func find_attack_targets():
	var range = _active_unit.active_weapon.range
	var cells = _flood_fill(_active_unit.cell, range, true)
	
	attack_targets.clear()
	
	for cell in cells:
		if _units.has(cell):
			var unit = _units[cell] as Unit
			if unit != _active_unit:
				attack_targets.append(unit)


func _attack_unit(cell: Vector2) -> void:
	if _units.has(cell):
		var unit = _units[cell] as Unit
		if unit != _active_unit:
			unit.damage(_active_unit.active_weapon.base_damage)
			end_action()


## Selects or moves a unit based on where the cursor is.
func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if attacking:
		_attack_unit(cell)
	elif not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected && !unit_moved:
		_move_active_unit(cell)
	elif _active_unit.cell == cell:
		_on_wait_pressed()


## Updates the interactive path's drawing if there's an active and selected unit.
func _on_Cursor_moved(new_cell: Vector2) -> void:
	if _active_unit and _active_unit.is_selected and !unit_moved:
		_unit_path.draw(_active_unit.cell, new_cell)


func _on_wait_pressed():
	end_action()


func _on_cancel_pressed():
	_units.erase(_active_unit.cell)
	_units[_origin_cell] = _active_unit
	_active_unit.set_grid_position(_origin_cell)
	end_action()


func end_action():
	_deselect_active_unit()
	_clear_active_unit()
	$ActionWindow.hide()
	_unit_overlay.clear()
	highlight_targets(false)


func highlight_targets(highlight):
	for target in attack_targets:
		target._highlighted = highlight


func _on_attack_pressed():
	attacking = true
	highlight_targets(true)
	$ActionWindow.hide()
