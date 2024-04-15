class_name Mothership
extends Fleet_Structure

@export var troops: Array[Person]
@export var mothership_ui: Mothership_UI
var troop_cost: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_troop_cost()->int:
	if(troop_cost == -1):
		for p: Person in troops:
			#troop_cost += person.tier
			pass
	return troop_cost

func try_add_person(new_person: Person)->bool:
	var total_cost = get_troop_cost()
	#if the person's tier is too expensive, return false
	troops.append(new_person)
	return true

func is_valid_troop()->bool:
	if(troops.size() <= 0):
		return false
	if(troop_cost > capacity):
		return false
	var has_valid_unit = false
	var has_invalid_unit = false
	for p: Person in troops:
		#if unit is resting, mark invalid to true
		if(p != null):
			has_valid_unit = true
	
	return has_valid_unit && !has_invalid_unit
		 

func remove_dead_troops():
	#also check for troops marked as dead
	troops = troops.filter(func(number): return number != null)

func get_deployed_troops():
	return troops.filter(func(number): return number != null)

	
