class_name Black_Market
extends Fleet_Structure

@export var items_to_purchase: Array[Equipment]
@export var item_prices: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func refresh():
	items_to_purchase.clear()
	item_prices.clear()
	for i in capacity:
		scout_item()
		


func scout_item():
	var new_item
	#generate new person: people_generator.generate()
	items_to_purchase.append(new_item)
	#add their price to the price list
	var new_price
	item_prices.append(new_price)
	

func can_purchase(id: int)-> bool:
	if(id >= capacity || id < 0):
		return false
	if(items_to_purchase[id] == null):
		return false
	if(manager.get_current_money() < item_prices[id]):
		return false
	if(manager.at_max_items()):
		return false
	return true


func purchase(id: int) -> bool:
	if(!can_purchase(id)):
		return false
	
	manager.add_new_item(items_to_purchase[id])
	manager.spend_money(item_prices[id])
	items_to_purchase.remove_at(id)
	items_to_purchase.insert(id, null)
	item_prices.remove_at(id)
	item_prices.insert(id, null)
	return true
