class_name Stim_Pack
extends Gear


func _active_ability(target: Unit):
	var stim_effect = Stim_Effect.new(1, 1)
	target.add_status_effect(stim_effect)
