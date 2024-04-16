extends Node

var inventory: Inventory_Menu

func open_inventory(person: Person):
	if(inventory == null):
		inventory = get_tree().current_scene.get_node("FleetUI/Background/Inventory_Menu")
	inventory.display_person(person)
