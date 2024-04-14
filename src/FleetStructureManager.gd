class_name Fleet_Structure_Manager
extends Node

@export var reserves: Reserve
@export var structures: Array[Fleet_Structure]
@export var black_market: Black_Market
@export var healing_vats: Healing_Vats
@export var rift: Rift
@export var mothership: Mothership

# Called when the node enters the scene tree for the first time.
func _ready():
	for structure: Fleet_Structure in structures:
		structure.refresh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func get_current_money()->int:
	return reserves.money
	
func add_money(new_money: int):
	reserves.add_money(new_money)

func spend_money(spent_money: int):
	reserves.spend_money(spent_money)
	
func at_max_units()->bool:
	return reserves.army_full()
	
func at_max_items()->bool:
	return reserves.stockpile_full()
	

func add_new_unit(new_unit: Person):
	reserves.add_unit_to_army(new_unit)

func add_new_item(new_item: Equipment):
	reserves.add_equipment_to_stockpile(new_item)


