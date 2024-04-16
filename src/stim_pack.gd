class_name Stim_Pack
extends Gear


func _active_ability(target: Unit):
	target.stims = true
