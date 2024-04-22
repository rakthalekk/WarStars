class_name Fleet_Structure_UI
extends Control

@export var main_ui: Fleet
@export var gold_ui: Label

func open_ui():
	update_money_text()
	#main_ui.menu_opened(self)
	pass

func on_close_ui():
	print("closing menu")
	main_ui.menu_closed()
	AudioManager.play_click()

func check_prices():
	pass

func get_structure()->Fleet_Structure:
	return null

func update_money_text():
	gold_ui.text = str(main_ui.reserves.money)



