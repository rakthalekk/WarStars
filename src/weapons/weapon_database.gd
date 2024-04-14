extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func _get_weapon_by_name(weapon_name: String) -> Weapon:
	return get_node(weapon_name)
	
func get_generator()->Equipment_Generator:
	return get_node("Equipment_Generator")
