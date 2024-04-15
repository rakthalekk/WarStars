class_name Fleet_Structure_UI
extends Control

@export var main_ui: Fleet

func open_ui():
	main_ui.menu_opened(self)

func on_close_ui():
	print("closing menu")
	main_ui.menu_closed()

func check_prices():
	pass


