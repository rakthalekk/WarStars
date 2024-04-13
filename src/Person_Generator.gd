class_name Person_Generator
extends Node2D

@export var rank_1_chance = .6
@export var rank_2_chance = .3
@export var rank_3_chance = .1

var generator : Equipment_Generator

# Called when the node enters the scene tree for the first time.
func _ready():
	var generator : Equipment_Generator
	generator = get_node("Equipment_Generator") # Replace with path to the actual equipment generator node when possible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_unit() -> Person:
	var unit = get_node("Unit")
	
	var rank_chance_total = rank_1_chance + rank_2_chance + rank_3_chance
	var rank_roll = randf_range(0, rank_chance_total)
	var rank = 1
	if rank_roll < rank_3_chance:
		rank = 3
	elif rank_roll < rank_2_chance:
		rank = 2
	unit.raise_tier_to(rank)
	# Generate equipment
	var weapon1 = generator.spawn_random_weapon_at_tier(unit.tier)
	unit.equip(0, weapon1)
	var weapon2 = generator.spawn_random_weapon_up_to_tier(unit.tier - 1)
	unit.equip(1, weapon2)
	
	var gear1 = generator.spawn_random_gear_up_to_tier(unit.tier)
	unit.equip(2, gear1)
	var gear2 = generator.spawn_random_gear_up_to_tier(unit.tier - 1)
	unit.equip(3, gear2)
	return unit
