class_name Inventory_Drop_Area
extends Drop_Area

@export var main_inventory: Inventory_Menu
@export var equip2: bool = false
@export var gear: Gear
@export var main_image: TextureRect

func start_overlap():
	super.start_overlap()
	main_inventory.highlight(true, equip2)
	if(gear != null):
		MouseDrag.display_gear_tooltip(gear)

func end_overlap():
	super.end_overlap()
	main_inventory.highlight(false, equip2)
	if(gear != null):
		MouseDrag.hide_gear_tooltip(gear)

func drop_object(obj: Drag_Icon)->bool:
	print("dropping in inventory slot")
	if(obj.gear_icon != null):
		main_inventory.try_give_equipment(obj.gear_icon.equip, equip2)
	return true

func assign_gear(new_gear: Gear):
	gear = new_gear
	main_image.texture = gear.image

func clear_gear(image: Texture):
	gear = null
	main_image.texture = image




