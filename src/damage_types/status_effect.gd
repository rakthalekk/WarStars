class_name Status_Effect
extends Node2D

enum EFFECT_TYPE {BURN, ACID, DAZE}

var target: Unit
@export var magnitude: int
@export var type: EFFECT_TYPE
@export var duration: int
var original_stat
@export var applied_every_turn: bool = false
@export var max_magnitude = 3

func _init(effect_level: int = 1, effect_duration: int = 1):
	magnitude = effect_level
	duration = effect_duration + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_action_end():
	if applied_every_turn:
		_apply_effect()
	duration -= 1
	if duration == 0:
		_remove_effect()
		queue_free()

func _apply_effect():
	pass

func _remove_effect():
	pass
	
func _save_stat():
	pass
	
func add_effect_to_target(unit: Unit):
	return
	target = unit
	var existing_effect = get_tree().get_node(str(target.get_path(), "/", name))
	if existing_effect == null:
		target = unit
		unit.add_child(self)
		target.end_unit_action.connect(on_action_end)
		_save_stat()
	else:
		existing_effect.magnitude = max(existing_effect.magnitude + magnitude, max_magnitude)
		existing_effect.duration = (duration + existing_effect.duration) / 2
		
	if not applied_every_turn:
		_apply_effect()
