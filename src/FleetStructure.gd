class_name Fleet_Structure
extends Node

@export var manager: Fleet_Structure_Manager
@export var capacity: int = 3
@export var level: int = 1
@export var max_level: int = 5
@export var upgrade_price: int = 500
@export var upgrade_2_price: int = 2000
@export var upgrade_increase_mult: float = 1.5
@export var capacity_increase: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func refresh():
	pass
	
func Set_Manager(new_manager: Fleet_Structure_Manager):
	manager = new_manager
	
func can_afford_upgrade()->bool:
	return manager.get_current_money() >= upgrade_price
	
func is_max_level()->bool:
	return level >= max_level

func get_cost()->int:
	if(level == 1):
		return upgrade_price
	elif(level == 2):
		return upgrade_2_price
	return 0

func can_upgrade()-> bool:
	return can_afford_upgrade() && !is_max_level()

func upgrade_capacity():
	print("trying to upgrade capacity of ",self)
	if(level == 3):
		return
	manager.spend_money(upgrade_price)
	capacity += capacity_increase
	level += 1

func get_money()->int:
	return manager.get_current_money()
