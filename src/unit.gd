## Represents a unit on the game board.
## The board manages its position inside the game grid.
## The unit itself holds stats and a visual representation that moves smoothly in the game world.
class_name Unit
extends Path2D

## Emitted when the unit reached the end of a path along which it was walking.
signal walk_finished

signal die(unit: Unit)

## Distance to which the unit can walk in cells.
@export var move_range := 6
## The unit's move speed when it's moving along a path.
@export var move_speed := 600.0
## The unit's health stat
@export var max_health := 8
## The unit's tier
@export var tier := 1
## the player's head texture
@export var texture: Texture
## the player's head color
@export var color: Color

var person_source: Person

@export var weapon_names: Array[String]

var death_sounds = [preload("res://assets/sounds/DEATH 1.mp3"), preload("res://assets/sounds/DEATH 1.mp3")]
var footstep_sounds = [preload("res://assets/sounds/Footstep 1.mp3"), preload("res://assets/sounds/Footstep 2.mp3"), preload("res://assets/sounds/Footstep 3.mp3")]
var damage_sounds = [preload("res://assets/sounds/DMG 1.mp3"), preload("res://assets/sounds/DMG 2.mp3"), preload("res://assets/sounds/DMG 3.mp3"), preload("res://assets/sounds/DMG 4.mp3")]

var health: int

var idle_anim = "idle"

signal end_unit_action(unit: Unit)

const DEATH_SOUND = preload("res://src/death_sound.tscn")

## Coordinates of the current cell the cursor moved to.
var cell := Vector2.ZERO:
	set(value):
		# When changing the cell's value, we don't want to allow coordinates outside
		#	the grid, so we clamp them
		cell = ChunkDatabase.grid_clamp(value)
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
		$PathFollow2D/Highlight.visible = value

var acted := false:
	set(value):
		acted = value
		if acted:
			$AnimationPlayer.play("inactive")
		else:
			$AnimationPlayer.play(idle_anim)

var weapons: Array[Equipment]
var active_weapon: Equipment

#var gear_list: Array[Gear]
var armor: int

var stims: bool = false

@onready var _path_follow: PathFollow2D = $PathFollow2D
@onready var health_bar = $PathFollow2D/HealthBar/Health as TextureProgressBar
@onready var effects_anim = $EffectsAnimation
@onready var damage_display = $DamageDisplay
@onready var heat_display = $HeatDisplay


func _ready() -> void:
	set_process(false)
	_path_follow.rotates = false

	cell = ChunkDatabase.calculate_grid_coordinates(position)
	position = ChunkDatabase.calculate_map_position(cell)
	
	health = max_health
	health_bar.max_value = max_health
	
	for weapon_name in weapon_names:
		var weapon = WeaponDatabase._get_weapon_by_name(weapon_name).clone()
		weapon.user = self
		weapons.append(weapon)
	
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
		position = ChunkDatabase.calculate_map_position(cell)
		curve.clear_points()
		emit_signal("walk_finished")


func set_grid_position(pos: Vector2):
	cell = pos
	position = ChunkDatabase.calculate_map_position(cell)


## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.size() <= 1:
		await get_tree().create_timer(0.05).timeout
		emit_signal("walk_finished")
		return
	
	$FootstepSound.stream = footstep_sounds.pick_random()
	$FootstepSound.play()
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(ChunkDatabase.calculate_map_position(point) - position)
	cell = path[-1]
	_is_walking = true


func damage(dmg: int):
	dmg = max(0, dmg - armor)
	health = max(0, health - dmg)
	health_bar.value = health
	
	damage_display.text = str(-dmg) + " HP"
	
	$DamageSound.stream = damage_sounds.pick_random()
	$DamageSound.play()
	
	effects_anim.play("damage_flash")
	await effects_anim.animation_finished
	
	if health == 0:
		var sound = DEATH_SOUND.instantiate()
		get_parent().add_child(sound)
		sound.play_sound(death_sounds.pick_random())
		
		emit_signal("die", self)


func play_heat_gain(heat: int):
	heat_display.text = str(heat) + " HEAT"
	effects_anim.play("heat_flash")
	await effects_anim.animation_finished


func switch_weapons(index: int):
	if index >= 0 and index <= 3:
		active_weapon = weapons[index]
	
func end_action():
	end_unit_action.emit()
	
func add_status_effect(effect: Status_Effect):
	effect.target = self
	var existing_effect = get_node(str(effect.name))
	if existing_effect == null:
		effect.target = self
		add_child(effect)
		end_unit_action.connect(effect.on_action_end)
		effect._save_stat()
	else:
		existing_effect.magnitude = max(existing_effect.magnitude + effect.magnitude, effect.max_magnitude)
		existing_effect.duration = (effect.duration + existing_effect.duration) / 2
		
	if not effect.applied_every_turn:
		effect._apply_effect()

#func use_gear(index: int, target):
#	gear_list[index].use_active(target)
