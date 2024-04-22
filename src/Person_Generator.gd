extends Node2D

@export var rank_1_chance = .6
@export var rank_2_chance = .3
@export var rank_3_chance = .1
@export var image_picker: Person_Image_Picker
var generator : Equipment_Generator

# Called when the node enters the scene tree for the first time.
func _ready():
	generator = WeaponDatabase.get_generator()
	
	for i in range(4):
		GameManager.reserve_list.append(generate_player_unit())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_unit(tier = -1, reduce_ranged_chance = false) -> Person:
	var unit = Person.new()
	unit.max_health = 6 + randi_range(1, 3)
	
	var two_weapons = true
	
	var rank = 1
	if tier == 0:
		rank = 1
		two_weapons = false
	elif tier != -1:
		rank = tier
	else:
		var rank_chance_total = rank_1_chance + rank_2_chance + rank_3_chance
		var rank_roll = randf_range(0, rank_chance_total)
		if rank_roll < rank_3_chance:
			rank = 3
		elif rank_roll < rank_2_chance + rank_3_chance:
			rank = 2
	
	unit.raise_tier_to(rank)
	
	var one_below_tier : int
	if unit.tier == 1:
		one_below_tier = 1
	else:
		one_below_tier = unit.tier - 1
	
	var disallowed_types = [] as Array[Equipment_Generator.Weapon_Type]
	
	# Enemies have a lower chance of getting rifles or pistols
	if reduce_ranged_chance:
		var rand = randf()
		if rand < 0.5:
			disallowed_types.append(Equipment_Generator.Weapon_Type.RIFLE)
		elif rand < 0.7:
			disallowed_types.append(Equipment_Generator.Weapon_Type.PISTOL)
	
	# Generate equipment
	var weapon1 = generator.spawn_random_weapon_at_tier(unit.tier, disallowed_types)
	unit.equip(0, weapon1)
	
	disallowed_types.append(weapon1.weapon_type)
	
	if two_weapons:
		var weapon2 = generator.spawn_random_weapon_up_to_tier(one_below_tier, disallowed_types)
		unit.equip(1, weapon2)
	
	var gear_roll = randi_range(0, 2)
	if gear_roll > 0:
		var gear1 = generator.spawn_random_gear_up_to_tier(unit.tier)
		unit.equip(2, gear1)
	if gear_roll > 1:
		var gear2 = generator.spawn_random_gear_up_to_tier(one_below_tier)
		unit.equip(3, gear2)
	
	return unit


func generate_player_unit(tier = -1) -> Person:
	var unit = generate_unit(tier)
	
	unit.image = image_picker.get_image()
	unit.color = image_picker.get_color()
	unit.name = GameManager.get_random_name()
	
	return unit


func generate_enemy_unit(tier = -1) -> Person:
	var unit = generate_unit(tier, true)
	
	unit.name = "Empire Soldier"
	
	return unit
