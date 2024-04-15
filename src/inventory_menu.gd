class_name Inventory_Menu
extends Control

@export var reserves: Reserve
@export var person: Person
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

func refresh():
	person_image.texture = null
	name_label.text = ""
	health_label.text = ""
	speed_label.text = ""
	weapon_1_image.texture = null
	weapon_1_label.text = ""
	weapon_2_image.texture = null
	weapon_2_label.text = ""
	equip_1_image.texture = null
	equip_1_label.text = ""
	equip_2_image.texture = null
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

func display_person(person:Person):
	person_image.texture = person.image
	name_label.text = person.name
	health_label.text = str(person.health) + "/" + str(person.max_health)
	speed_label.text = str(person.speed)
	weapon_1_image.texture = person.weapon1.image
	weapon_1_label.text = person.weapon1.name
	weapon_2_image.texture = person.weapon2.image
	weapon_2_label.text = person.weapon2.name
	if(person.equip1 != null):
		equip_1_image.texture = person.equip1.image
		equip_1_label.text = person.equip1.name
	else:
		equip_1_image.texture = null
		equip_1_label.text = "NONE"
	if(person.equip2 != null):
		equip_2_image.texture = person.equip2.image
		equip_2_label.text = person.equip2.name
	else:
		equip_2_image.texture = null
		equip_2_label.text = "NONE"
	
	if(!visible):
		open_inventory()
	

func try_give_equipment_1(new_equip: Gear):
	if(person.equip1 != null):
		return
	person.equip1 = new_equip
	reserves.remove_equipment(new_equip)
	equip_1_image.texture = person.equip1.image
	equip_1_label.text = person.equip1.name

func try_give_equipment_2(new_equip: Gear):
	if(person.equip2 != null):
		return
	person.equip2 = new_equip
	reserves.remove_equipment(new_equip)
	equip_2_image.texture = person.equip2.image
	equip_2_label.text = person.equip2.name

func display_inventory():
	for i in reserves.stockpile:
		spawn_new_equip(i)

func close_inventory():
	refresh()
	visible = false

func spawn_new_equip(equip: Equipment):
	var new_icon:Equip_Icon = base_item_icon.duplicate()
	new_icon.set_equip(equip)
	new_icon.visible = true
	equip_parent.add_child(new_icon)
	print("new icon: ", new_icon)
	
