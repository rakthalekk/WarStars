class_name Gear
extends Equipment

@export var num_uses: int = -1
var uses_left: int = 0
@export var use_cooldown: int = 0
var cooldown_counter: int = 0
@export var uses_action: bool = true
@export var passive_hp_buff: int = 0
@export var passive_move_buff: int = 0
@export var passive_armor: int = 0
@export var cost: int = 0

func can_use_active():
	return super.can_use_active() && cooldown_counter <= 0 && (num_uses < 0 || uses_left > 0)

func use_active() -> bool:
	
	if(!can_use_active()):
		return false
		
	#actually use the active ability
	cooldown_counter = use_cooldown
	return true
	
	

#make this take a player parameter
func use_passive():
	pass
	
func rest():
	if(cooldown_counter > 0):
		cooldown_counter -= 1

func prep_for_battle():
	cooldown_counter = 0
	uses_left = num_uses
	
func get_cost():
	if cost == 0:
		var rand = randf() * .5 + .85
		cost = rarity * 75 * rand
	return cost

