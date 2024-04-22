extends Node2D
class_name Person

var weapon1 : Weapon
var weapon2 : Weapon

var equip1 : Gear
var equip2 : Gear

@export var base_price = 150
@export var weapon_price_base = 20
@export var gear_price_base = 25

@export var image: Texture
@export var color: Color = Color.WHITE
var price = 100

var tier = 1
@export var max_health = 8
var health = max_health
@export var speed = 6
var armor = 0

@export var min_health_gain = 2
@export var max_health_gain = 5

const max_tier = 3

@export var resting: bool
@export var fighting: bool

const player_unit_scene = preload("res://src/player_unit.tscn")
const enemy_unit_scene = preload("res://src/enemy_unit.tscn")

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

func construct_unit(unit: Unit) -> Unit:
	unit.max_health = max_health
	unit.health = health
	unit.move_range = speed
	unit.tier = tier
	unit.person_source = self
	unit.texture = image
	unit.color = color
	unit.armor = armor
	unit.set_sprites(image, color)
	
	unit.weapons.append(weapon1)
	weapon1.user = unit
	
	if weapon2:
		unit.weapons.append(weapon2)
		weapon2.user = unit
	
	if equip1 != null:
		unit.weapons.append(equip1)
	if equip2 != null:
		unit.weapons.append(equip2)
		
	unit.name = name
	
	return unit


func construct_player_unit() -> PlayerUnit:
	var unit = player_unit_scene.instantiate()
	unit = construct_unit(unit)
	return unit


func construct_enemy_unit() -> EnemyUnit:
	var unit = enemy_unit_scene.instantiate()
	unit = construct_unit(unit)
	return unit


func update_from_unit(unit: Unit):
	health = unit.health
	
	var unit_gear = unit.weapons
		
	# update used gear
	if unit_gear.size() >= 3 and unit_gear[2] == equip1 and unit_gear[2].is_consumable and unit_gear[2].num_uses == 0:
		equip1 = null
	elif unit_gear.size() >= 4 and unit_gear[3] == equip2 and unit_gear[3].is_consumable and unit_gear[3].num_uses == 0:
		equip2 = null
