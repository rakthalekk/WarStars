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

var self_targeting = false

var player_turn = false

var ui_up = false

var enemy_with_overlay: EnemyUnit


@onready var action_window = get_parent().get_node("ActionWindow")
@onready var animation_player = get_parent().get_node("AnimationPlayer")

@onready var _unit_overlay: UnitOverlay = $UnitOverlay
@onready var _unit_attack_range: UnitOverlay = $UnitAttackRange
@onready var _unit_path: UnitPath = $UnitPath
@onready var _danger_area: UnitOverlay = $DangerArea
@onready var _enemy_unit_overlay: UnitOverlay = $EnemyUnitOverlay
@onready var _enemy_attack_range: UnitOverlay = $EnemyAttackRange

@onready var map: TileMap = get_parent().get_node("Map")
@onready var camera: Camera2D = get_parent().get_node("Camera2D")
@onready var combat_ui: Control = get_parent().get_node("UI/CombatUI")
@onready var chapter_end_ui: Control = get_parent().get_node("UI/ChapterEndControl")

func _ready() -> void:
	_reinitialize()
	change_turn()
	chapter_end_ui.hide()
	display_danger_area()


func _process(delta):
	if _active_unit and (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("right_click")):
		if attacking:
			highlight_targets(false)
			action_window.display()
			$Cursor.active = false
			attacking = false
		elif self_targeting:
			highlight_self(false)
			action_window.display()
			$Cursor.active = false
			self_targeting = false
		elif !_active_unit._is_walking:
			if action_window.get_node("Submenu").visible:
				action_window._on_action_cancel_pressed()
			else:
				cancel_action()
	
	if GameManager.controller:
		var cursor_to_camera = $Cursor.position - camera.position
		if cursor_to_camera.x < -100:
			camera.position += Vector2(-1.5, 0)
		elif cursor_to_camera.x > 100:
			camera.position += Vector2(1.5, 0)
		if cursor_to_camera.y < -60:
			camera.position += Vector2(0, -1.5)
		elif cursor_to_camera.y > 60:
			camera.position += Vector2(0, 1.5)
	else:
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
	return _flood_fill(unit.cell, unit.move_range, false, unit is PlayerUnit)


## Clears, and refills the `_units` dictionary with game objects that are on the board.
func _reinitialize() -> void:
	action_window.hide()
	_units.clear()
	var player_chunk_tiles = ChunkDatabase.get_player_chunk().get_used_cells(1)

	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		
		if unit is PlayerUnit:
			player_units.append(unit)
			# Set unit's position
			var random_tile = player_chunk_tiles[randi_range(0, player_chunk_tiles.size() - 1)]
			while is_occupied(random_tile):
				random_tile = player_chunk_tiles[randi_range(0, player_chunk_tiles.size() - 1)]
			unit.set_grid_position(random_tile)
		elif unit is EnemyUnit:
			enemy_units.append(unit)
			
		_units[unit.cell] = unit
		unit.connect("die", remove_unit)


## Returns an array with all the coordinates of walkable cells based on the `max_distance`.
func _flood_fill(cell: Vector2, max_distance: int, attack_range: bool, is_player: bool) -> Array:
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
			if !attack_range && walkable:
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
		
		var path_length = 0
		var path = _pathfinder.calculate_point_path(cell, current)
		for pos in path:
			var forest = map.get_cell_tile_data(0, pos).get_custom_data("forest")
			if forest:
				path_length += 2
			else:
				path_length += 1
		
		if path_length > max_distance + 1:
			continue
		
		array.append(current)
		
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if coordinates in array:
				continue
			
			if not ChunkDatabase.is_within_bounds(coordinates):
				continue
			
			var walkable = map.get_cell_tile_data(0, coordinates).get_custom_data("walkable")
			
			if !attack_range && is_occupied(coordinates):
				if is_player && _units[coordinates] is EnemyUnit || !is_player && _units[coordinates] is PlayerUnit:
					continue
			
			if !attack_range && !walkable:
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
	
	$Cursor.active = false
	
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
	
	var atk_range = []
	for walk in _walkable_cells:
		var attack_cells = _flood_fill(walk, unit.active_weapon.range, true, true)
		
		for location in attack_cells:
			var attackable = map.get_cell_tile_data(0, location).get_custom_data("attackable")
			if !attackable && cell.distance_to(location) > 1:
				continue
			
			if not location in _walkable_cells:
				atk_range.append(location)
	
	_unit_attack_range.draw(atk_range)


func _display_enemy_overlay(unit: EnemyUnit) -> void:
	if unit == enemy_with_overlay:
		enemy_with_overlay = null
		_enemy_unit_overlay.clear()
		_enemy_attack_range.clear()
	else:
		var cells = get_walkable_cells(unit)
		var atk_range = []
		for cell in cells:
			var attack_cells = _flood_fill(cell, unit.active_weapon.range, true, false)
			for atk_cell in attack_cells:
				var attackable = map.get_cell_tile_data(0, atk_cell).get_custom_data("attackable")
				if !attackable && cell.distance_to(unit.cell) > 1:
					continue
				
				if not atk_cell in cells:
					atk_range.append(atk_cell)
			
		_enemy_unit_overlay.draw(cells)
		_enemy_attack_range.draw(atk_range)
		enemy_with_overlay = unit


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
	action_window.display()
	$Cursor.active = false


func find_attack_targets():
	var range = _active_unit.active_weapon.range
	var cells = _flood_fill(_active_unit.cell, range, true, true)
	
	attack_targets.clear()
	
	var cells2 = cells.duplicate()
	
	for cell in cells:
		var attackable = map.get_cell_tile_data(0, cell).get_custom_data("attackable")
		if !attackable && cell.distance_to(_active_unit.cell) > 1:
			continue
		
		if _units.has(cell):
			var unit = _units[cell]
			if unit is EnemyUnit:
				attack_targets.append(unit)


func _attack_unit(cell: Vector2, initiator = _active_unit) -> void:
	if _units.has(cell) and (initiator.active_weapon is Weapon 
		or (initiator.active_weapon is Gear and (initiator.active_weapon.use_type == Gear.USE_TYPE.ENEMY))):
		var unit = _units[cell]
		
		var attackable = map.get_cell_tile_data(0, cell).get_custom_data("attackable")
		
		if !attackable && cell.distance_to(initiator.cell) > 1:
			return
		
		if initiator is PlayerUnit && unit is EnemyUnit:
			if not unit in attack_targets:
				return
			
			await unit.damage(initiator.active_weapon.damage)
			await initiator.active_weapon.perform_specialty(unit)
			attacking = false
			end_action()
		elif initiator is EnemyUnit && unit is PlayerUnit:
			await initiator.active_weapon.use_active(unit)


func remove_unit(unit: Unit):
	_units.erase(unit.cell)
	
	if unit in player_units:
		player_units.erase(unit)
	elif unit in enemy_units:
		enemy_units.erase(unit)
		# Completes level if all enemies are defeated if either the defend or route contracts are selected
		if GameManager.currentContract && (GameManager.currentContract.type == GameManager.Contract_Type.DEFEND || GameManager.currentContract.type == GameManager.Contract_Type.ROUTE) && enemy_units.size() == 0:
			chapter_end()
	
	display_danger_area()
	
	unit.queue_free()


## Selects or moves a unit based on where the cursor is.
func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if !player_turn || action_window.visible:
		return
	
	if attacking:
		await _attack_unit(cell)
	elif not _active_unit:
		if _units.has(cell):
			if _units[cell] is PlayerUnit:
				_select_unit(cell)
			else:
				_display_enemy_overlay(_units[cell])
	elif _active_unit.is_selected && !unit_moved:
		_move_active_unit(cell)
	elif _active_unit.cell == cell:
		if self_targeting and _active_unit.active_weapon is Gear and _active_unit.active_weapon.use_type == Gear.USE_TYPE.SELF:
			if _active_unit.active_weapon.use_active(_active_unit):
				end_action()
			else:
				highlight_self(false)
				self_targeting = false
		else:
			end_action()


## Updates the interactive path's drawing if there's an active and selected unit.
func _on_Cursor_moved(new_cell: Vector2) -> void:
	if !player_turn:
		return
	
	if !_active_unit:
		if _units.has(new_cell):
			var unit = _units[new_cell] as Unit
			combat_ui.get_node("HealthBar").frame = 17 - unit.health
			combat_ui.get_node("Name").text = unit.name
			display_unit_weapons(unit, unit.weapons[0], combat_ui.get_node("Weapon"))
			
			combat_ui.show()
		else:
			combat_ui.hide()
	elif _active_unit.is_selected and !unit_moved:
		_unit_path.show()
		_unit_path.draw(_active_unit.cell, new_cell)


func display_unit_weapons(unit: Unit, weapon: Weapon, image: TextureRect):
	var weapon_name = "WS_Emprie_" if unit is EnemyUnit else "WS_Troupe_"
	match weapon.name:
		"Laser":
			weapon_name += "Pistol.png"
		"Shotgun":
			weapon_name += "Shotty.png"
		"Melee":
			weapon_name += "Lance.png"
		_:
			weapon_name += weapon.name + ".png"
	
	image.texture = load("res://assets/Weapons & Gear/" + weapon_name)

func cancel_action():
	$Cursor.active = true
	_units.erase(_active_unit.cell)
	_units[_origin_cell] = _active_unit
	_active_unit.set_grid_position(_origin_cell)
	_unit_path.hide()
	
	highlight_self(false)
	_deselect_active_unit()
	_clear_active_unit()
	action_window.hide()
	_unit_overlay.clear()
	_unit_attack_range.clear()
	highlight_targets(false)


func end_action():
	if GameManager.currentContract && GameManager.currentContract.type == GameManager.Contract_Type.CAPTURE && _active_unit.cell == GameManager.capture_tile:
		chapter_end()
	$Cursor.active = true
	if !_active_unit.stims:
		_active_unit.acted = true
		_active_unit.end_action()
	else:
		_active_unit.stims = false
	highlight_self(false)
	_deselect_active_unit()
	_clear_active_unit()
	action_window.hide()
	_unit_overlay.clear()
	_unit_attack_range.clear()
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

func chapter_end():
	GameManager.chapter_complete = true
	chapter_end_ui.get_node("ChapterEndButton").grab_focus()
	$Cursor.active = false
	for unit in player_units:
		unit.person_source.update_from_unit(unit)
	chapter_end_ui.show()


func change_turn():
	_enemy_attack_range.clear()
	_enemy_unit_overlay.clear()
	display_danger_area()
	
	player_turn = !player_turn
	print('not your turn abymore buddy!!!')
	attacking = false
	unit_moved = false
	
	for unit in _units.values():
		unit.acted = false
	
	if player_turn:
		# Completes the chapter if the player selected a defend contract and they have defended for the necessary amount of turns
		if GameManager.currentContract && GameManager.currentContract.type == GameManager.Contract_Type.DEFEND && GameManager.currentContract.defend_turns == GameManager.current_turn:
			chapter_end()
			return
		GameManager.incrementTurns()
		animation_player.play("player_turn_start")
		for unit in player_units:
			var damaging = map.get_cell_tile_data(0, unit.cell).get_custom_data("damaging")
			if damaging:
				await unit.damage(2)
	else:
		animation_player.play("enemy_turn_start")
		for unit in enemy_units:
			var damaging = map.get_cell_tile_data(0, unit.cell).get_custom_data("damaging")
			if damaging:
				await unit.damage(2)
		
		await animation_player.animation_finished
		enemy_turn()


func enemy_turn():
	for enemy in enemy_units:
		_walkable_cells = get_walkable_cells(enemy)
		_unit_path.initialize(_walkable_cells)
		await check_enemy_range(enemy)
	
	change_turn()


func display_danger_area():
	_danger_area.clear()
	
	var danger_area = []
	for enemy in enemy_units:
		var movement_options = _flood_fill(enemy.cell, enemy.move_range, false, false)
		for tile in movement_options:
			if not tile in danger_area:
				danger_area.append(tile)
			
			var possible_targets = _flood_fill(tile, enemy.active_weapon.range, true, false)
			for target in possible_targets:
				# If the opponent is in grass, make sure the path is 1 away
				var attackable = map.get_cell_tile_data(0, target).get_custom_data("attackable")
				if !attackable && target.distance_to(tile) > 1:
					continue
				
				if not target in danger_area:
					danger_area.append(target)
				
	
	_danger_area.draw(danger_area)


func check_enemy_range(enemy: EnemyUnit):
	var movement_options = _flood_fill(enemy.cell, enemy.move_range, false, false)
	var number_of_targets = 0
	for destination in movement_options:
		var possible_targets = _flood_fill(destination, enemy.active_weapon.range, true, false)
		for target in possible_targets:
			if _units.has(target):
				if _units[target] is PlayerUnit:
					number_of_targets += 1
					# If the opponent is in grass, make sure the path is 1 away
					var attackable = map.get_cell_tile_data(0, target).get_custom_data("attackable")
					if !attackable && target.distance_to(destination) > 1:
						continue
					
					_unit_path.update_path(enemy.cell, destination)
					
					# destination and target
					await _move_enemy_unit(destination, enemy)
					await _attack_unit(target, enemy)
					
					display_danger_area()
					
					return
	if number_of_targets == 0 && GameManager.currentContract:
		await no_attack_ai(enemy, movement_options)
	
	
func no_attack_ai(enemy: EnemyUnit, movement_options: Array):
	var rng = RandomNumberGenerator.new()
	match GameManager.currentContract.type:
		GameManager.Contract_Type.CAPTURE:
			match GameManager.currentContract.difficulty_stars:
				1:
					var wait_check = rng.randi_range(1, 10)
					# 70% chance to wait
					if wait_check <= 7:
						return
					var random_tile = movement_options[rng.randi_range(0, movement_options.size() - 1)]
					if random_tile == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, random_tile)
					await _move_enemy_unit(random_tile, enemy)
					display_danger_area()
				2:
					var wait_check = rng.randi_range(1, 10)
					# 60% chance to wait
					if wait_check <= 6:
						return
					var random_tile = movement_options[rng.randi_range(0, movement_options.size() - 1)]
					if random_tile == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, random_tile)
					await _move_enemy_unit(random_tile, enemy)
					display_danger_area()
				3:
					var wait_check = rng.randi_range(1, 10)
					# 50% chance to wait
					if wait_check <= 5:
						return
					var closest_tile_to_capture_point = enemy.cell
					for tile_destination in movement_options:
						if tile_destination.distance_to(GameManager.capture_tile) < closest_tile_to_capture_point.distance_to(GameManager.capture_tile) && !is_occupied(tile_destination):
							closest_tile_to_capture_point = tile_destination
					if closest_tile_to_capture_point == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_capture_point)
					await _move_enemy_unit(closest_tile_to_capture_point, enemy)
					display_danger_area()
				4:
					var wait_check = rng.randi_range(1, 10)
					# 30% chance to wait
					if wait_check <= 3:
						return
					var closest_tile_to_capture_point = enemy.cell
					for tile_destination in movement_options:
						if tile_destination.distance_to(GameManager.capture_tile) < closest_tile_to_capture_point.distance_to(GameManager.capture_tile) && !is_occupied(tile_destination):
							closest_tile_to_capture_point = tile_destination
					if closest_tile_to_capture_point == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_capture_point)
					await _move_enemy_unit(closest_tile_to_capture_point, enemy)
					display_danger_area()
				5:
					# 0% chance to wait
					var closest_tile_to_capture_point = enemy.cell
					for tile_destination in movement_options:
						if tile_destination.distance_to(GameManager.capture_tile) < closest_tile_to_capture_point.distance_to(GameManager.capture_tile) && !is_occupied(tile_destination):
							closest_tile_to_capture_point = tile_destination
					if closest_tile_to_capture_point == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_capture_point)
					await _move_enemy_unit(closest_tile_to_capture_point, enemy)
					display_danger_area()
		GameManager.Contract_Type.DEFEND:
			match GameManager.currentContract.difficulty_stars:
				1:
					var wait_check = rng.randi_range(1, 10)
					# 70% chance to wait
					if wait_check <= 7:
						return
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
				2:
					var wait_check = rng.randi_range(1, 10)
					# 60% chance to wait
					if wait_check <= 6:
						return
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
				3:
					var wait_check = rng.randi_range(1, 10)
					# 50% chance to wait
					if wait_check <= 5:
						return
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
				4:
					var wait_check = rng.randi_range(1, 10)
					# 30% chance to wait
					if wait_check <= 3:
						return
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
				5:
					# 0% chance to wait
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
					
		GameManager.Contract_Type.ROUTE:
			match GameManager.currentContract.difficulty_stars:
				1:
					var wait_check = rng.randi_range(1, 10)
					# 70% chance to wait
					if wait_check <= 7:
						return
					var random_tile = movement_options[rng.randi_range(0, movement_options.size() - 1)]
					if random_tile == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, random_tile)
					await _move_enemy_unit(random_tile, enemy)
					display_danger_area()
				2:
					var wait_check = rng.randi_range(1, 10)
					# 60% chance to wait
					if wait_check <= 6:
						return
					var random_tile = movement_options[rng.randi_range(0, movement_options.size() - 1)]
					if random_tile == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, random_tile)
					await _move_enemy_unit(random_tile, enemy)
					display_danger_area()
				3:
					var wait_check = rng.randi_range(1, 10)
					# 50% chance to wait
					if wait_check <= 5:
						return
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
				4:
					var wait_check = rng.randi_range(1, 10)
					# 30% chance to wait
					if wait_check <= 3:
						return
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()
				5:
					# 0% chance to wait
					var closest_tile_to_player = enemy.cell
					for tile_destination in movement_options:
						var player_tile = player_units[rng.randi_range(0, player_units.size() - 1)].cell
						if tile_destination.distance_to(player_tile) < closest_tile_to_player.distance_to(player_tile) && !is_occupied(tile_destination):
							closest_tile_to_player = tile_destination
					if closest_tile_to_player == enemy.cell:
						return
					_unit_path.update_path(enemy.cell, closest_tile_to_player)
					await _move_enemy_unit(closest_tile_to_player, enemy)
					display_danger_area()	
					
					
							
func highlight_targets(highlight):
	$Cursor.active = true
	for target in attack_targets:
		target._highlighted = highlight
		
func highlight_self(highlight):
	$Cursor.active = true
	_active_unit._highlighted = highlight
