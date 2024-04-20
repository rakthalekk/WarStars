class_name Fleet
extends Control

@export var fleet_manager: Fleet_Structure_Manager
@export var reserves: Reserve

@export var quick_menu: Mini_Menu
@export var rift_menu: Fleet_Structure_UI
@export var healing_vats_menu: Fleet_Structure_UI
@export var black_market_menu: Fleet_Structure_UI
@export var mothership_menu: Fleet_Structure_UI

var last_menu: Fleet_Structure_UI = null

func _init():
	GameManager.fleet = self

# Called when the node enters the scene tree for the first time.
func _ready():
	for person in GameManager.reserve_list:
		reserves.add_unit_to_army(person)
	#reserves.add_money(GameManager.currentContract.reward)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func open_rift_menu():
	menu_opened(rift_menu)

func open_black_market_menu():
	#print("button")
	menu_opened(black_market_menu)

func open_healing_vats_menu():
	menu_opened(healing_vats_menu)
	
func open_mothership_menu():
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
