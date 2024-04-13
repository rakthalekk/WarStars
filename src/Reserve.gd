class_name Reserve
extends Node

#your money
@export var money: int
#max units
@export var max_army_size: int = 100
#all available units at your disposal
@export var army: Array[Person]
#max items
@export var max_stockpile_size: int = 100
#all available unequipped equipment at your disposal (your inventory)
@export var stockpile: Array[Equipment]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func add_money(new_money: int):
	money += new_money

func spend_money(spent_money: int):
	money -= spent_money

#add a new unit to the army
func add_unit_to_army(new_person: Person):
	army.append(new_person)

func remove_unit_from_army(lost_unit: Person):
	if(army.has(lost_unit)):
		army.erase(lost_unit)
	else:
		print("could not find unit to remove ",lost_unit.equipment_name)
		
func get_army() -> Array:
	return army
	
func add_equipment_to_stockpile(new_equipment: Equipment):
	stockpile.append(new_equipment)
	
func remove_equipment(used_equipment: Equipment):
	if(stockpile.has(used_equipment)):
		stockpile.erase(used_equipment)
	else:
		print("could not find item to remove ",used_equipment.equipment_name)
		
func get_equipment_list() -> Array:
	return stockpile
	
func army_full() -> bool:
	return army.size() >= max_army_size
	
func stockpile_full() -> bool:
	return stockpile.size() >= max_stockpile_size
