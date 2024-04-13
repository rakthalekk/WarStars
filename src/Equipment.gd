class_name Equipment
extends Node

enum Equip_Type {WEAPON, CONSUMABLE, GEAR}

@export var equipment_name: String
@export var rarity: int = 1
@export var weight: int
@export var has_active: bool
@export var has_passive: bool
@export var equip_type: Equip_Type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func use_active() -> bool:
	return false
	
func can_use_active():
	return has_active

#make this take a player parameter
func use_passive():
	pass

func rest():
	pass

func prep_for_battle():
	pass