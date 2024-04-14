class_name Rift
extends Fleet_Structure

@export var people_to_summon: Array[Person]
@export var summon_prices: Array[int]

var people_generator

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func refresh():
	people_to_summon.clear()
	summon_prices.clear()
	for i in capacity:
		scout_summon()

func upgrade_capacity():
	super.upgrade_capacity()
	scout_summon()
	
	
func scout_summon():
	var new_person
	#generate new person: people_generator.generate()
	people_to_summon.append(new_person)
	#add their price to the price list
	var new_price
	summon_prices.append(new_price)
	
	

func can_summon(id: int)-> bool:
	if(id >= capacity || id < 0):
		return false
	if(people_to_summon[id] == null):
		return false
	if(manager.get_current_money() < summon_prices[id]):
		return false
	if(manager.at_max_units()):
		return false
	return true

func summon(id: int) -> bool:
	if(!can_summon(id)):
		return false
	
	manager.add_new_unit(people_to_summon[id])
	manager.spend_money(summon_prices[id])
	people_to_summon.remove_at(id)
	people_to_summon.insert(id, null)
	summon_prices.remove_at(id)
	summon_prices.insert(id, null)
	return true
