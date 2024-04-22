class_name Fleet
extends Control

@export var fleet_manager: Fleet_Structure_Manager
@export var reserves: Reserve

@export var quick_menu: Mini_Menu
@export var rift_menu: Fleet_Structure_UI
@export var healing_vats_menu: Fleet_Structure_UI
@export var black_market_menu: Fleet_Structure_UI
@export var mothership_menu: Fleet_Structure_UI
@export var inventory_menu: Inventory_Menu

var last_menu: Fleet_Structure_UI = null

func _init():
	GameManager.fleet = self

# Called when the node enters the scene tree for the first time.
func _ready():
	for person in GameManager.reserve_list:
		reserves.add_unit_to_army(person)
	#reserves.add_money(GameManager.currentContract.reward)
	
	if InventoryMenuListener.inventory == null:
		InventoryMenuListener.inventory = $FleetUI/Background/Inventory_Menu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func open_rift_menu():
	AudioManager.play_click()
	menu_opened(rift_menu)

func open_black_market_menu():
	#print("button")
	AudioManager.play_click()
	menu_opened(black_market_menu)

func open_healing_vats_menu():
	AudioManager.play_click()
	menu_opened(healing_vats_menu)
	
func open_mothership_menu():
	AudioManager.play_click()
	menu_opened(mothership_menu)

func menu_opened(new_menu: Fleet_Structure_UI):
	if(last_menu != null):
		last_menu.visible = false
	quick_menu.visible = true
	last_menu = new_menu
	new_menu.visible = true
	new_menu.open_ui()
	

func menu_closed():
	quick_menu.visible = false
	quick_menu.on_close_mini_menu()
	if(last_menu != null):
		last_menu.visible = false
		last_menu = null
	
	GameManager.help_menu_title = "Fleet"
	GameManager.help_menu_description = "The fleet allows you to manage your army between battles. Click on any of the icons to access another menu. Double click a unit on the right to access their info."

func refresh():
	mothership_menu.hide()
	quick_menu.visible = false
	quick_menu.on_close_mini_menu()
	inventory_menu.close_inventory()
	reserves.refresh()
	fleet_manager.refresh()

func add_funds(money: int):
	reserves.add_money(money)

func end_mission(reward: int):
	add_funds(reward)
	refresh()
