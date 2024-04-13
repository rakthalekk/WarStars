extends Node2D
class_name Person

var weapon1 : Node2D
var weapon2 : Node2D

var equip1 : Node2D
var equip2 : Node2D

@export var base_price = 100
@export var weapon_price_base = 25
@export var price = 100

var _tier = 1
@export var health = 8
@export var speed = 10

@export var min_health_gain = 2
@export var max_health_gain = 5

@export var max_tier = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	price 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Raise the tier to a specified value. Capped at max_tier.
func raise_tier_to(new_tier : int):
	if new_tier > max_tier:
		new_tier = max_tier
	if new_tier < _tier:
		return
	
	while(_tier < new_tier):
		_tier += 1
		health += randi_range(min_health_gain, max_health_gain)
		price += base_price

# Raise tier by 1
func raise_tier():
	raise_tier_to(_tier + 1)

func equip(slot : int, equipment : Node2D):
	match slot:
		0:
			# Check that it's a weapon, otherwise return
			#if equipment is Weapon:
			weapon1 = equipment
			#else: return
		1:
			# Check that it's a weapon, otherwise return
			#if equipment is Weapon:
			weapon2 = equipment
			#else: return
		2:
			# Check that it's not a weapon, otherwise return
			#if not equipment is Weapon:
			equip1 = equipment
			#else: return
		3:
			# Check that it's not a weapon, otherwise return
			#if not equipment is Weapon:
			equip2 = equipment
			#else: return
	# Call equipment's stat change function
	price += equipment.tier * weapon_price_base
