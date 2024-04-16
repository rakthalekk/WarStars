class_name Inventory_Drop_Area
extends Drop_Area

@export var main_inventory: Inventory_Menu
@export var equip2: bool = false

func start_overlap():
	super.start_overlap()
	main_inventory.highlight(true, equip2)

func end_overlap():
	super.end_overlap()
	main_inventory.highlight(false, equip2)

func drop_object(obj: Drag_Icon)->bool:
	print("dropping in inventory slot")
	if(obj.gear_icon != null):
		main_inventory.try_give_equipment(obj.gear_icon.equip, equip2)
	return true


