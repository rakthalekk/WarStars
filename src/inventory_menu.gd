class_name Inventory_Menu
extends Control

@export var inventory: Array[Equip_Icon]
@export var reserves: Reserve
@export var person: Person
@export var default_texture: Texture
@export var base_item_icon: Equip_Icon
@export var equip_parent: Node
@export var person_image: TextureRect
@export var name_label: Label
@export var health_label: Label
@export var speed_label: Label
@export var weapon_1_image: TextureRect
@export var weapon_1_label: Label
@export var weapon_2_image: TextureRect
@export var weapon_2_label: Label
@export var equip_1_image: TextureRect
@export var equip_1_label: Label
@export var equip_2_image: TextureRect
@export var equip_2_label: Label
var default_color: Color = Color.WHITE
var highlight_color: Color = Color.BLUE

func refresh():
	person_image.texture = default_texture
	name_label.text = ""
	health_label.text = ""
	speed_label.text = ""
	weapon_1_image.texture = default_texture
	weapon_1_label.text = ""
	weapon_2_image.texture = default_texture
	weapon_2_label.text = ""
	equip_1_image.texture = default_texture
	equip_1_label.text = ""
	equip_2_image.texture = default_texture
	equip_2_label.text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_inventory():
	display_inventory()
	visible = true

func display_person(new_person:Person):
	person = new_person
	person_image.texture = person.image
	person_image.modulate = person.color
	name_label.text = person.name
	health_label.text = "HP: " + str(person.health) + "/" + str(person.max_health)
	speed_label.text = "Move: " + str(person.speed)
	weapon_1_image.texture = person.weapon1.image
	weapon_1_label.text = person.weapon1.name
	weapon_2_image.texture = person.weapon2.image
	weapon_2_label.text = person.weapon2.name
	if(person.equip1 != null):
		equip_1_image.texture = person.equip1.image
		equip_1_label.text = person.equip1.name
	else:
		equip_1_image.texture = default_texture
		equip_1_label.text = "NONE"
	if(person.equip2 != null):
		equip_2_image.texture = person.equip2.image
		equip_2_label.text = person.equip2.name
	else:
		equip_2_image.texture = default_texture
		equip_2_label.text = "NONE"
	
	if(!visible):
		open_inventory()
	

func highlight(highlight: bool, equip_2: bool):
	if(equip_2):
		highlight_2(highlight)
	else:
		highlight_1(highlight)

func highlight_1(highlight: bool):
	if(highlight && person.equip1 == null):
		equip_1_image.modulate = highlight_color
	else:
		equip_1_image.modulate = default_color
	
func highlight_2(highlight: bool):
	if(highlight && person.equip2 == null):
		equip_2_image.modulate = highlight_color
	else:
		equip_2_image.modulate = default_color
	

func try_give_equipment(new_equip: Gear, equip_2: bool):
	print("try to give equipment")
	if(equip_2):
		try_give_equipment_2(new_equip)
	else:
		try_give_equipment_1(new_equip)

func try_give_equipment_1(new_equip: Gear):
	if(person.equip1 != null):
		return
	person.equip1 = new_equip
	reserves.remove_equipment(new_equip)
	equip_1_image.texture = person.equip1.image
	equip_1_label.text = person.equip1.name
	delete_object(new_equip)
	

func try_give_equipment_2(new_equip: Gear):
	if(person.equip2 != null):
		return
	person.equip2 = new_equip
	reserves.remove_equipment(new_equip)
	equip_2_image.texture = person.equip2.image
	equip_2_label.text = person.equip2.name
	delete_object(new_equip)

func delete_object(gear: Gear):
	print("trying to delete ",gear)
	for i in inventory.size():
		if(inventory[i].equip == gear):
			inventory[i].queue_free()
			inventory.remove_at(i)
			return
			

func display_inventory():
	for i in reserves.stockpile:
		spawn_new_equip(i)

func close_inventory():
	AudioManager.play_click()
	refresh()
	visible = false

func spawn_new_equip(equip: Equipment):
	var new_icon:Equip_Icon = base_item_icon.duplicate()
	new_icon.setup()
	new_icon.set_equip(equip)
	new_icon.visible = true
	equip_parent.add_child(new_icon)
	print("new icon: ", new_icon)
	inventory.append(new_icon)
	
