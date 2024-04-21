class_name Mini_Menu
extends Control

enum Menu_Type{MOTHERSHIP, RIFT, MARKET, VATS}

@export var fleet: Fleet
@export var mothership_UI: Fleet_Structure_UI
@export var mothership_button: TextureButton
@export var rift_UI: Fleet_Structure_UI
@export var rift_button: TextureButton
@export var black_market_UI: Fleet_Structure_UI
@export var black_market_button: TextureButton
@export var healing_vats_UI: Fleet_Structure_UI
@export var healing_vats_button: TextureButton

func set_current_menu(menu_type: Menu_Type):
	match(menu_type):
		Menu_Type.MOTHERSHIP:
			mothership_button.disabled = true
		Menu_Type.RIFT:
			rift_button.disabled = true
		Menu_Type.MARKET:
			black_market_button.disabled = true
		Menu_Type.VATS:
			healing_vats_button.disabled = true

func on_press_mothership_button():
	#AudioManager.play_click()
	fleet.menu_opened(mothership_UI)
	mothership_button.disabled = true
	rift_button.disabled = false
	black_market_button.disabled = false
	healing_vats_button.disabled = false
	
func on_press_rift_button():
	#AudioManager.play_click()
	fleet.menu_opened(rift_UI)
	mothership_button.disabled = false
	rift_button.disabled = true
	black_market_button.disabled = false
	healing_vats_button.disabled = false

func on_press_black_market_button():
	#AudioManager.play_click()
	fleet.menu_opened(black_market_UI)
	mothership_button.disabled = false
	rift_button.disabled = false
	black_market_button.disabled = true
	healing_vats_button.disabled = false

func on_press_vats_button():
	#AudioManager.play_click()
	fleet.menu_opened(healing_vats_UI)
	mothership_button.disabled = false
	rift_button.disabled = false
	black_market_button.disabled = false
	healing_vats_button.disabled = true
	
func on_close_mini_menu():
	mothership_button.disabled = false
	rift_button.disabled = false
	black_market_button.disabled = false
	healing_vats_button.disabled = false
