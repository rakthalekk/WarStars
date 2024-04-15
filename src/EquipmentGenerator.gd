class_name Equipment_Generator
extends Node2D

enum Weapon_Type{NONE, MELEE, PISTOL, SHOTGUN, RIFLE}

@export var base_melee: Equipment
@export var base_pistol: Equipment
@export var base_shotgun: Equipment
@export var base_rifle: Equipment
@onready var base_weapons: Array[Weapon] = [base_melee, base_pistol, base_shotgun, base_rifle]

#@export var base_gear: Array[Equipment]
@export var tier_1_gear: Array[Gear]
@export var tier_2_gear: Array[Gear]
@export var tier_3_gear: Array[Gear]

@export var tier_3_chance: float = 0.1
@export var tier_2_chance: float = 0.3
@export var tier_1_chance: float = 0.6

func _ready():
	for node in get_node("Gear").get_children():
		if node is Gear:
			match(node.rarity):
				(1): tier_1_gear.append(node)
				(2): tier_2_gear.append(node)
				(3): tier_3_gear.append(node)

func spawn_random_weapon_at_tier(tier: int, disallowed_type: Weapon_Type = Weapon_Type.NONE) -> Weapon:
	var valid_weapons
	if(disallowed_type == Weapon_Type.NONE):
		valid_weapons = base_weapons
	else:
		valid_weapons = base_weapons.duplicate()
		match(disallowed_type):
			Weapon_Type.MELEE:
				valid_weapons.erase(base_melee)
			Weapon_Type.PISTOL:
				valid_weapons.erase(base_pistol)
			Weapon_Type.SHOTGUN:
				valid_weapons.erase(base_shotgun)
			Weapon_Type.RIFLE:
				valid_weapons.erase(base_rifle)
	
	var random_int = randi() % valid_weapons.size()
	var random_weapon_type = valid_weapons.pick_random()
	
	
	var new_weapon = random_weapon_type.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS)
	new_weapon.generate_from_scratch(tier)
	return new_weapon

func spawn_weapon(tier: int, type: Weapon_Type)->Weapon:
	var weapon_to_spawn
	match(type):
		Weapon_Type.MELEE:
			weapon_to_spawn = base_melee
		Weapon_Type.PISTOL:
			weapon_to_spawn = base_pistol
		Weapon_Type.SHOTGUN:
			weapon_to_spawn = base_shotgun
		Weapon_Type.RIFLE:
			weapon_to_spawn = base_rifle
	var new_weapon = weapon_to_spawn.clone(DuplicateFlags.DUPLICATE_SCRIPTS)
	new_weapon.generate_from_scratch(tier)
	return new_weapon

func spawn_random_weapon(disallowed_type: Weapon_Type = Weapon_Type.NONE)-> Weapon:
	
	return spawn_random_weapon_at_tier(get_tier(), disallowed_type)
	

func spawn_random_weapon_up_to_tier(max_tier: int, disallowed_type: Weapon_Type = Weapon_Type.NONE):
	if(max_tier == 1):
		return spawn_random_weapon_at_tier(1, disallowed_type)
	if(max_tier == 2):
		var rand = randf() * 0.9;
		if rand <= tier_1_chance:
			return spawn_random_weapon_at_tier(1, disallowed_type)
		else:
			return spawn_random_weapon_at_tier(2, disallowed_type)
	else:
		spawn_random_weapon(disallowed_type)

func get_tier(max_tier: int = 3)->int:
	if max_tier == 1:
		return 1
	
	var rand = randf();
	if max_tier == 2:
		rand *= 0.9
	
	var tier
	if rand <= tier_1_chance:
		tier = 1
	elif rand <= tier_2_chance:
		tier = 2
	else:
		tier = 3
	return tier

func spawn_random_gear_up_to_tier(max_tier: int):
	return spawn_random_gear_at_tier(get_tier(max_tier))

func spawn_random_gear()->Gear:
	return spawn_random_gear_at_tier(get_tier())
	

func spawn_random_gear_at_tier(tier: int)-> Gear:
	var gear_to_copy
	match tier:
		1:
			gear_to_copy = tier_1_gear.pick_random()
		2:
			gear_to_copy = tier_2_gear.pick_random()
		3:
			gear_to_copy = tier_3_gear.pick_random()
	return gear_to_copy.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS)


