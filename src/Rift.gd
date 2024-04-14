class_name Rift
extends Fleet_Structure

@export var people_to_summon: Array[Person]
@export var ui: Rift_UI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func refresh():
	print("refreshing rift")
	people_to_summon.clear()
	for i in capacity:
		scout_summon()
	ui.refresh()
	print("capacity: ",capacity,". people_to_summon size: ",people_to_summon.size())

func upgrade_capacity():
	super.upgrade_capacity()
	scout_summon()
	ui.refresh()
	
	
func scout_summon():
	var new_person
	new_person = PersonGenerator.generate_unit()
	people_to_summon.append(new_person)
	#add their price to the price list
	var new_price = new_person.price
	print("scouting summon: ",new_person)
	

func has_summon(id: int)-> bool:
	if(id >= capacity || id < 0):
		return false
	if(people_to_summon[id] == null):
		return false
	return true

func can_summon(id: int)-> bool:
	if(id >= capacity || id < 0):
		return false
	if(people_to_summon[id] == null):
		return false
	if(manager.get_current_money() < people_to_summon[id].price):
		return false
	if(manager.at_max_units()):
		return false
	return true

func summon(id: int) -> bool:
	if(!can_summon(id)):
		return false
	
	manager.add_new_unit(people_to_summon[id])
	manager.spend_money(people_to_summon[id].price)
	#people_to_summon.remove_at(id)
	#people_to_summon.insert(id, null)
	people_to_summon[id] = null
	ui.refresh()
	return true


func get_summon(id: int)->Person:
	if(id < 0 || id >= capacity):
		return null
	return people_to_summon[id]


