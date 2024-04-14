class_name Black_Market
extends Fleet_Structure

@export var items_to_purchase: Array[Gear]
@export var ui: Black_Market_UI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func refresh():
	items_to_purchase.clear()
	for i in capacity:
		scout_item()
	ui.refresh()
		


func scout_item():
	var new_item = WeaponDatabase.get_generator().spawn_random_gear()
	items_to_purchase.append(new_item)
	

func can_purchase(id: int)-> bool:
	if(id >= capacity || id < 0):
		return false
	if(items_to_purchase[id] == null):
		return false
	if(manager.get_current_money() < items_to_purchase[id].get_cost()):
		return false
	if(manager.at_max_items()):
		return false
	return true


func purchase(id: int) -> bool:
	if(!can_purchase(id)):
		return false
	
	manager.add_new_item(items_to_purchase[id])
	manager.spend_money(items_to_purchase[id].get_cost())
	items_to_purchase.remove_at(id)
	items_to_purchase.insert(id, null)
	return true
