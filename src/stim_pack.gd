class_name Stim_Pack
extends Gear


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _active_ability(target: Unit):
	var stim_effect = Stim_Effect.new()
	stim_effect.add_effect_to_target(target)
