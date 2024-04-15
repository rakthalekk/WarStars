class_name Weapon
extends Equipment

enum Specialty_Type{NONE, BURN, STUN, ACID, PLASMA}
enum Upgrade_Type{SPECIALTY, DAMAGE, RANGE, HEAT}

@export var weapon_type: Equipment_Generator.Weapon_Type = Equipment_Generator.Weapon_Type.NONE
@export var is_melee: bool
@export var heat_gain: int
@export var heat_max: int = 6
@export var heat_cooldown: int = 1
var current_heat: int
var overheated: bool
@export var damage: int
@export var specialty: Specialty_Type
@export var specialty_tier: int = 0
@export var specialties: Array[Specialty_Type] = [Specialty_Type.BURN, Specialty_Type.STUN, Specialty_Type.ACID, Specialty_Type.PLASMA]
@export var upgrade_types: Array[Upgrade_Type] = [Upgrade_Type.SPECIALTY, Upgrade_Type.DAMAGE, Upgrade_Type.RANGE, Upgrade_Type.HEAT]

@export var range_tier_bonus: int = 1
@export var damage_tier_bonus: int = 1
@export var heat_tier_bonus: int = 2

func clone() -> Weapon:
	var clone = super.clone()
	clone.weapon_type = weapon_type
	clone.is_melee = is_melee
	clone.heat_gain = heat_gain
	clone.heat_max = heat_max
	clone.heat_cooldown = heat_cooldown
	clone.damage = damage
	clone.specialty = specialty
	clone.specialty_tier = specialty_tier
	clone.specialties = specialties
	clone.upgrade_types = upgrade_types

	clone.range_tier_bonus = range_tier_bonus
	clone.damage_tier_bonus = damage_tier_bonus
	clone.heat_tier_bonus = heat_tier_bonus
	
	return clone

func can_use_active():
	return super.can_use_active() && !overheated

func use_active(target = null) -> bool:
	if not target is Unit:
		return false
	if(!can_use_active()):
		return false
	
	#use weapon
	await target.damage(damage)
	perform_specialty(target)
	
	current_heat += heat_gain
	if(current_heat >= heat_max):
		current_heat = heat_max
		overheated = true
	return true
	
func rest():
	current_heat = maxi(0,current_heat - heat_cooldown)
	

func generate_from_scratch(tier: int):
	rarity = 0
	for i in tier:
		upgrade()
	
func upgrade():
	if(rarity == 3):
		return
	rarity += 1
	
	var random_selection = randi() % upgrade_types.size()
	var random_upgrade = upgrade_types[random_selection]

	apply_upgrade(random_upgrade)
	
	if(rarity < 3):
		return
	
	var second_upgrade_options = upgrade_types.duplicate()
	second_upgrade_options.remove_at(random_selection)
	
	random_selection = randi() % second_upgrade_options.size()
	random_upgrade = second_upgrade_options[random_selection]
	
	apply_upgrade(random_upgrade)
	

func apply_upgrade(upgrade_type: Upgrade_Type):
	match upgrade_type:
		Upgrade_Type.SPECIALTY:
			if(specialty == Specialty_Type.NONE):
				var random_specialty = randi() % specialties.size()
				specialty = specialties[random_specialty]
				specialty_tier = 1
			else:
				specialty_tier += 1
			
		Upgrade_Type.DAMAGE:
			damage += damage_tier_bonus
		Upgrade_Type.RANGE:
			range += range_tier_bonus
		Upgrade_Type.HEAT:
			heat_max += heat_tier_bonus

func prep_for_battle():
	current_heat = 0
	
func perform_specialty(target: Unit):
	match(specialty):
		(Specialty_Type.NONE):
			return
		(Specialty_Type.BURN):
			var burn_effect = Burn.new()
			burn_effect.magnitude = specialty_tier
			burn_effect.add_effect_to_target(target)
		(Specialty_Type.ACID):
			var acid_effect = Acid.new()
			acid_effect.magnitude = specialty_tier
			acid_effect.add_effect_to_target(target)
		(Specialty_Type.STUN):
			var stun_effect = Daze.new()
			stun_effect.magnitude = specialty_tier
			stun_effect.add_effect_to_target(target)
		(Specialty_Type.PLASMA):
			return
