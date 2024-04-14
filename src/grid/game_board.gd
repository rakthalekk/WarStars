## Represents and manages the game board. Stores references to entities that are in each cell and
## tells whether cells are occupied or not.
## Units can only move around the grid one at a time.
class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}
var _active_unit: Unit
var _walkable_cells := []
var _origin_cell = Vector2.ZERO

var player_units = []
var enemy_units = []

var unit_moved := false
var attack_targets: Array[Unit]

var attacking = false

var player_turn = false

var ui_up = false

@onready var action_window = get_parent().get_node("ActionWindow")
@onready var animation_player = get_parent().get_node("AnimationPlayer")

@onready var _unit_overlay: UnitOverlay = $UnitOverlay
@onready var _unit_path: UnitPath = $UnitPath

@onready var map: TileMap = get_parent().get_node("Map")
@onready var camera: Camera2D = get_parent().get_node("Camera2D")
@onready var combat_ui: Control = get_parent().get_node("UI/CombatUI")

func _ready() -> void:
	_reinitialize()
	change_turn()


func _process(delta):
	if _active_unit and (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("right_click")):
		if attacking:
			highlight_targets(false)
			action_window.display()
			attacking = false
		elif !_active_unit._is_walking:
			cancel_action()
	
	var camera_pan = get_local_mouse_position() - camera.position
	camera_pan = Vector2(camera_pan.x / 200.0, camera_pan.y / 112.0)
	
	if _active_unit == null && camera_pan.length() > .8:
		camera.position += camera_pan


func _get_configuration_warning() -> String:
	var warning := ""
	if not ChunkDatabase:
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
	action_window.hide()
	_units.clear()

	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit
		unit.connect("die", remove_unit)
		
		if unit is PlayerUnit:
			player_units.append(unit)
		elif unit is EnemyUnit:
			enemy_units.append(unit)


## Returns an array with all the coordinates of walkable cells based on the `max_distance`.
func _flood_fill(cell: Vector2, max_distance: int, attack_range = false) -> Array:
	var walkable_ish_grid = []
	var upper_left = Vector2(cell.x - max_distance - 1, cell.y - max_distance)
	for x in range(upper_left.x, upper_left.x + max_distance * 2 + 1):
		if x <= 0 || x >= ChunkDatabase.size.x:
			continue
		for y in range(upper_left.y, upper_left.y + max_distance * 2 + 1):
			if y <= 0 || y >= ChunkDatabase.size.y:
				continue
			
			var vector = Vector2(x, y)
			var walkable = map.get_cell_tile_data(0, vector).get_custom_data("walkable")
			if walkable:
				walkable_ish_grid.append(vector)
	
	var _pathfinder = PathFinder.new(walkable_ish_grid)
	
	var array := []
	var stack := [cell]
	while not stack.size() == 0:
		var current = stack.pop_back()
		if not ChunkDatabase.is_within_bounds(current):
			continue
		if current in array:
			continue

		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue
		
		var path_size = _pathfinder.calculate_point_path(cell, current).size()
		
		if path_size > max_distance + 1:
			continue
		
		array.append(current)
		
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if coordinates in array:
				continue
			
			if not ChunkDatabase.is_within_bounds(coordinates):
				continue
			
			var walkable = map.get_cell_tile_data(0, coordinates).get_custom_data("walkable")
			
			if !attack_range && (is_occupied(coordinates) || !walkable):
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
	if _active_unit:
		_popup_action_window(_active_unit.position)


func _move_enemy_unit(new_cell: Vector2, unit: EnemyUnit) -> void:
	if new_cell == unit.cell:
		set_unit_moved(true)
	
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	# warning-ignore:return_value_discarded
	_units.erase(unit.cell)
	_units[new_cell] = unit
	set_unit_moved(true)
	unit.walk_along(_unit_path.current_path)
	await unit.walk_finished


## Selects the unit in the `cell` if there's one there.
## Sets it as the `_active_unit` and draws its walkable cells and interactive move path. 
func _select_unit(cell: Vector2) -> void:
	if not _units.has(cell):
		return
	
	var unit = _units[cell]
	if unit.acted or not unit is PlayerUnit:
		return
	
	combat_ui.hide()
	
	_active_unit = unit
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)
	_origin_cell = _active_unit.cell


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
	
	action_window.update_buttons()
	
	action_window.position = pos + Vector2(10, -20)
	action_window.visible = true


func find_attack_targets():
	var range = _active_unit.active_weapon.range
	var cells = _flood_fill(_active_unit.cell, range, true)
	
	attack_targets.clear()
	
	for cell in cells:
		if _units.has(cell):
			var unit = _units[cell]
			if unit is EnemyUnit:
				attack_targets.append(unit)


func _attack_unit(cell: Vector2, initiator = _active_unit) -> void:
	if _units.has(cell):
		var unit = _units[cell]
		if initiator is PlayerUnit && unit is EnemyUnit:
			unit.damage(initiator.active_weapon.damage)
			initiator.active_weapon.perform_specialty(unit)
			attacking = false
			end_action()
		elif initiator is EnemyUnit && unit is PlayerUnit:
			unit.damage(initiator.active_weapon.damage)
			initiator.active_weapon.perform_specialty(unit)


func remove_unit(unit: Unit):
	_units.erase(unit.cell)
	
	if unit in player_units:
		player_units.erase(unit)
	elif unit in enemy_units:
		enemy_units.erase(unit)
	
	unit.queue_free()


## Selects or moves a unit based on where the cursor is.
func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if !player_turn:
		return
	
	if attacking:
		_attack_unit(cell)
	elif not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected && !unit_moved:
		_move_active_unit(cell)
	elif _active_unit.cell == cell:
		end_action()


## Updates the interactive path's drawing if there's an active and selected unit.
func _on_Cursor_moved(new_cell: Vector2) -> void:
	if !player_turn:
		return
	
	if !_active_unit:
		if _units.has(new_cell):
			combat_ui.show()
		else:
			combat_ui.hide()
	elif _active_unit.is_selected and !unit_moved:
		_unit_path.draw(_active_unit.cell, new_cell)


func cancel_action():
	_units.erase(_active_unit.cell)
	_units[_origin_cell] = _active_unit
	_active_unit.set_grid_position(_origin_cell)
	_unit_path.hide()
	
	_deselect_active_unit()
	_clear_active_unit()
	action_window.hide()
	_unit_overlay.clear()
	highlight_targets(false)


func end_action():
	_active_unit.acted = true
	_active_unit.end_action()
	_deselect_active_unit()
	_clear_active_unit()
	action_window.hide()
	_unit_overlay.clear()
	highlight_targets(false)
	
	attack_targets.clear()
	
	check_end_turn()


func check_end_turn():
	if player_turn:
		check_acted(player_units)
	else:
		check_acted(enemy_units)


func check_acted(units):
	var any_active = false
	for fella in units:
		if !fella.acted:
			any_active = true
			break
	
	if !any_active:
		change_turn()


func change_turn():
	player_turn = !player_turn
	print('not your turn abymore buddy!!!')
	attacking = false
	unit_moved = false
	
	for unit in _units.values():
		unit.acted = false
	
	for unit in player_units:
		unit.acted = false
	
	if player_turn:
		animation_player.play("player_turn_start")
	else:
		animation_player.play("enemy_turn_start")
		await animation_player.animation_finished
		enemy_turn()


func enemy_turn():
	for enemy in enemy_units:
		_walkable_cells = get_walkable_cells(enemy)
		_unit_path.initialize(_walkable_cells)
		await check_enemy_range(enemy)
	
	change_turn()


func check_enemy_range(enemy: EnemyUnit):
	var movement_options = _flood_fill(enemy.cell, enemy.move_range)
	for destination in movement_options:
		var possible_targets = _flood_fill(destination, enemy.active_weapon.range, true)
		for target in possible_targets:
			if _units.has(target):
				if _units[target] is PlayerUnit:
					_unit_path.update_path(enemy.cell, destination)
					
					# destination and target
					await _move_enemy_unit(destination, enemy)
					_attack_unit(target, enemy)
					return


func highlight_targets(highlight):
	for target in attack_targets:
		target._highlighted = highlight
