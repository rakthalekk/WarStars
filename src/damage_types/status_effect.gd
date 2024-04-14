class_name Status_Effect
extends Node2D

enum EFFECT_TYPE {BURN, ACID, DAZE}

var target: Unit
@export var magnitude: int
@export var type: EFFECT_TYPE
@export var duration: int
var original_stat
@export var applied_every_turn: bool = false

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
	target = unit
	var existing_effect = get_node(str(target.get_path(), "/", name))
	if existing_effect == null:
		target = unit
		target.end_unit_action.connect(on_action_end)
		_save_stat()
	else:
		existing_effect.magnitude += magnitude
		existing_effect.duration = max(duration, existing_effect.duration)
		
	if not applied_every_turn:
		_apply_effect()
