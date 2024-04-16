extends Gear


func _active_ability(target: Unit):
	target.health = min(target.health + rarity * 3, target.max_health)
