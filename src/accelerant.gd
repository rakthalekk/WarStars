class_name Accelerant
extends Gear


func _active_ability(target: Unit):
	var accel_effect = Accel_Effect.new(2 * rarity, 1)
	target.add_status_effect(accel_effect)
