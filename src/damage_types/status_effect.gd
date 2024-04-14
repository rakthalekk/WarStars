class_name Status_Effect
extends Node2D

enum EFFECT_TYPE {BURN, ACID, STUN}

var target: Unit
var magnitude: int
var type: EFFECT_TYPE
var duration: int

# Called when the node enters the scene tree for the first time.
func _ready():
	target.end_unit_action.connect(on_action_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_action_end():
	duration -= 1
	if duration == 0:
		remove_effect()
		queue_free()

func apply_effect():
	pass

func remove_effect():
	pass
