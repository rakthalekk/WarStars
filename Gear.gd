class_name Gear
extends Equipment

@export var num_uses: int = -1
var _uses_left: int = 0
@export var use_cooldown: int = 0
var cooldown_counter: int = 0
@export var uses_action: bool = true
@export var passive_hp_buff: int = 0
@export var passive_move_buff: int = 0
@export var passive_armor: int = 0
@export var cost: int = 0
@export var is_consumable: bool = false

func _ready():
	prep_for_battle()
	
func clone() -> Gear:
	var clone: Gear = super.clone()
	clone.num_uses = num_uses
	clone._uses_left = _uses_left
	clone.use_cooldown = use_cooldown
	clone.uses_action = uses_action
	clone.passive_hp_buff = passive_hp_buff
	clone.passive_move_buff = passive_move_buff
	clone.passive_armor = passive_armor
	clone.cost = cost
	clone.is_consumable = is_consumable
	
	return clone
	
func can_use_active():
	return super.can_use_active() && cooldown_counter <= 0 && (num_uses < 0 || _uses_left > 0)

func use_active(target = null) -> bool:
	
	if(!can_use_active()):
		return false
	
	#actually use the active ability
	_active_ability(target)
	
	cooldown_counter = use_cooldown
	
	# Decrement remaining uses, if applicable
	if _uses_left > 0:
		_uses_left -= 1
	
	return true
	
func _active_ability(target):
	pass
	
func apply_stat_changes(person: Person):
	super.apply_stat_changes(person)
	person.max_health += passive_hp_buff
	person.speed += passive_move_buff
	person.armor += passive_armor

func rest():
	if(cooldown_counter > 0):
		cooldown_counter -= 1

func prep_for_battle():
	cooldown_counter = 0
	_uses_left = num_uses
	
func get_cost():
	if cost == 0:
		var rand = randf() * .5 + .85
		cost = rarity * 75 * rand
	return cost

