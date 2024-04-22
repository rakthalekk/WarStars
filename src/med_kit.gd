extends Gear


func _active_ability(target: Unit):
	target.health = min(target.health + rarity * 4, target.max_health)
	target.health_bar.value = target.health
