## Represents a unit on the game board.
## The board manages its position inside the game grid.
## The unit itself holds stats and a visual representation that moves smoothly in the game world.
class_name Unit
extends Path2D

## Emitted when the unit reached the end of a path along which it was walking.
signal walk_finished

signal die(unit: Unit)

## Shared resource of type Grid, used to calculate map coordinates.
@export var grid: Resource
## Distance to which the unit can walk in cells.
@export var move_range := 6
## The unit's move speed when it's moving along a path.
@export var move_speed := 600.0
## The unit's health stat
@export var health := 8
## The unit's tier
@export var tier := 1

@export var weapon_names: Array[String]

## Coordinates of the current cell the cursor moved to.
var cell := Vector2.ZERO:
	set(value):
		# When changing the cell's value, we don't want to allow coordinates outside
		#	the grid, so we clamp them
		cell = grid.grid_clamp(value)
## Toggles the "selected" animation on the unit.
var is_selected := false:
	set(value):
		is_selected = value

var _is_walking := false:
	set(value):
		_is_walking = value
		set_process(_is_walking)

var _highlighted := false:
	set(value):
		_highlighted = value
		$Highlight.visible = value

var acted := false:
	set(value):
		acted = value
		if acted:
			$AnimationPlayer.play("inactive")

var weapons: Array[WeaponData]
var active_weapon: WeaponData

@onready var _path_follow: PathFollow2D = $PathFollow2D


func _ready() -> void:
	set_process(false)
	_path_follow.rotates = false

	cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
	
	for weapon_name in weapon_names:
		weapons.append(WeaponDatabase._get_weapon_by_name(weapon_name))
	
	active_weapon = weapons[0]

	# We create the curve resource here because creating it in the editor prevents us from
	# moving the unit.
	if not Engine.is_editor_hint():
		curve = Curve2D.new()


func _process(delta: float) -> void:
	_path_follow.progress += move_speed * delta

	if _path_follow.progress_ratio >= 1.0:
		_is_walking = false
		# Setting this value to 0.0 causes a Zero Length Interval error
		_path_follow.progress = 0.00001
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		emit_signal("walk_finished")


func set_grid_position(pos: Vector2):
	cell = pos
	position = grid.calculate_map_position(cell)


## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return

	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	cell = path[-1]
	_is_walking = true


func damage(dmg: int):
	health = max(0, health - dmg)
	if health == 0:
		emit_signal("die", self)