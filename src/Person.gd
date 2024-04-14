extends Node2D
class_name Person

var weapon1 : Weapon
var weapon2 : Weapon

var equip1 : Gear
var equip2 : Gear

@export var base_price = 150
@export var weapon_price_base = 20
@export var gear_price_base = 25
var price = 100

var tier = 1
@export var max_health = 8
var health = max_health
@export var speed = 6
var armor = 0

@export var min_health_gain = 2
@export var max_health_gain = 5

const max_tier = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	price = base_price + randi_range(0, 25)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Raise the tier to a specified value. Capped at max_tier.
func raise_tier_to(new_tier : int):
	if new_tier > max_tier:
		new_tier = max_tier
	if new_tier < tier:
		return
	
	while(tier < new_tier):
		tier += 1
		max_health += randi_range(min_health_gain, max_health_gain)
		price += base_price
	health = max_health
# Raise tier by 1
func raise_tier():
	raise_tier_to(tier + 1)

func equip(slot : int, equipment : Equipment):
	match slot:
		0:
			# Check that it's a weapon, otherwise return
			if equipment.equip_type == Equipment.Equip_Type.WEAPON:
				weapon1 = equipment
				price += equipment.rarity * weapon_price_base
			else: return
		1:
			# Check that it's a weapon, otherwise return
			if equipment.equip_type == Equipment.Equip_Type.WEAPON:
				weapon2 = equipment
				price += equipment.rarity * weapon_price_base
			else: return
		2:
			# Check that it's not a weapon, otherwise return
			if not equipment.equip_type == Equipment.Equip_Type.WEAPON:
				equip1 = equipment
				price += equipment.rarity * gear_price_base
			else: return
		3:
			# Check that it's not a weapon, otherwise return
			if not equipment.equip_type == Equipment.Equip_Type.WEAPON:
				equip2 = equipment
				price += equipment.rarity * gear_price_base
			else: return
	equipment.apply_stat_changes(self)

func construct_unit():
	var unit = Unit.new()
	unit.max_health = max_health
	unit.health = health
	unit.move_range = speed
	unit.tier = tier
	unit.person_source = self
	
	unit.weapons.append(weapon1)
	unit.weapons.append(weapon2)
	
	unit.gear_list.append(equip1)
	unit.gear_list.append(equip2)
	
	return unit

func update_from_unit(unit: Unit):
	health = unit.health
	# TODO update lost/used gear
