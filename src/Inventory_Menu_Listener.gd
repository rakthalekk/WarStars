extends Node

var inventory: Inventory_Menu

func open_inventory(person: Person, single_click: bool = false):
	if(single_click && !inventory.visible):
		return
	inventory.display_person(person)


