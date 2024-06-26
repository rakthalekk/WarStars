class_name Black_Market_UI
extends Fleet_Structure_UI

@export var black_market_script: Black_Market
@export var purchase_panels: Array[Control]

func get_structure()->Fleet_Structure:
	return black_market_script

func open_ui():
	super.open_ui()
	GameManager.help_menu_title = "Black Market"
	GameManager.help_menu_description = "Click on any item to purchase it. Items can be equipped through the inventory and accessed in battle. Double click a unit on the right to open their inventory."
	refresh()

func _ready():
	refresh()

func try_purchase(id: int):
	if(black_market_script.purchase(id)):
		update_money_text()
		return true
		#purchase_panels[id].visible = false
	return false

func refresh():
	print("refreshing black market ui ", black_market_script.capacity)
	if(black_market_script == null):
		return
	for i in black_market_script.capacity:
		purchase_panels[i].setup(black_market_script.get_equip(i))
	for i in purchase_panels.size():
		purchase_panels[i].visible = i < black_market_script.capacity# && black_market_script.item_available(i)
		#mark as interactable only if you can afford its
	check_prices()

func check_prices():
	for i in black_market_script.capacity:
		#print("setting up black market panel ",i)
		var can_buy = black_market_script.can_purchase(i)
		purchase_panels[i].set_button_active(can_buy)
		purchase_panels[i].setup_money(black_market_script.get_money())

