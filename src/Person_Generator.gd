class_name Person_Generator
extends Node2D

@export var rank_1_chance = .6
@export var rank_2_chance = .3
@export var rank_3_chance = .1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_unit() -> Person:
	var generator = Equipment_Generator
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
	var weapon1 = generator.spawn_weapon(unit.tier)
	unit.equip(0, weapon1)
	var weapon2 = generator.spawn_weapon(unit.tier - 1)
	unit.equip(1, weapon2)
	var i = 2
	while i < 4:
		#var item = generate_gear(unit.tier, can be below)
		#unit.equip(i, item)
		i += 1
	return unit
