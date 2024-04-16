class_name Equipment
extends Node

enum Equip_Type {WEAPON, CONSUMABLE, GEAR}

enum USE_TYPE {NONE, ENEMY, SELF, TERRAIN}

@export var use_type: USE_TYPE = USE_TYPE.NONE
@export var equipment_description: String
@export var image: Texture

@export var rarity: int = 1
@export var weight: int = 0
@export var has_passive: bool
@export var equip_type: Equip_Type

@export var range: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clone() -> Equipment:
	var clone: Equipment = duplicate()
	clone.use_type = use_type
	clone.equipment_description = equipment_description
	clone.image = image
	clone.rarity = rarity
	clone.weight = weight
	clone.has_passive = has_passive
	clone.equip_type = equip_type
	clone.range = range
	return clone

func use_active(target = null) -> bool:
	return false
	
func can_use_active():
	return use_type != USE_TYPE.NONE

#make this take a player parameter
func apply_stat_changes(person: Person):
	person.speed -= weight

func rest():
	pass

func prep_for_battle():
	pass
