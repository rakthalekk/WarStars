class_name Equipment_Generator
extends Node2D

enum Weapon_Type{NONE, MELEE, PISTOL, SHOTGUN, RIFLE}

@export var base_melee: Equipment
@export var base_pistol: Equipment
@export var base_shotgun: Equipment
@export var base_rifle: Equipment
@export var base_weapons: Array[Equipment] = [base_melee, base_pistol, base_shotgun, base_rifle]

@export var base_gear: Array[Equipment]
@export var tier_1_gear: Array[Equipment]
@export var tier_2_gear: Array[Equipment]
@export var tier_3_gear: Array[Equipment]

@export var tier_3_chance: float = 0.1
@export var tier_2_chance: float = 0.3
@export var tier_1_chance: float = 0.6

func SpawnWeapon(tier: int, disallowed_type: Weapon_Type = Weapon_Type.NONE):
	


