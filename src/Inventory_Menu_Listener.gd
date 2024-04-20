extends Node

var inventory: Inventory_Menu

func open_inventory(person: Person, single_click: bool = false):
	if(inventory == null):
		inventory = get_tree().current_scene.get_node("FleetUI/Background/Inventory_Menu")
	if(single_click && !inventory.visible):
		return
	inventory.display_person(person)


