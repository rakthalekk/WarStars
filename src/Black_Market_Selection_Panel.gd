class_name Black_Market_Selection_Panel
extends UI_Selection_Panel

@export var market_UI: Black_Market_UI
@export var id: int
@export var equipment: Equipment

func on_button_click():
	AudioManager.play_click()
	if(market_UI.try_purchase(id)):
		#AudioManager.play_purchase()
		MouseDrag.hide_gear_tooltip(equipment)
		equipment = null
		gold_text.modulate = insufficient_gold_color
		set_button_active(false)
		

	
func setup(new_equip):
	#print("setting up piece of equipment " )
	if(new_equip == null):
		print("no equipment to setup")
		main_text.text = "SOLD"
		main_image.texture = default_image
		main_select_button.disabled = true
		return
	main_select_button.disabled = false;
	equipment = new_equip
	main_text.text = equipment.name
	price = equipment.get_cost()
	gold_text.text = str(price)
	main_image.texture = equipment.image
	
	

func set_button_active(active: bool):
	main_select_button.disabled = !active && equipment != null

func setup_money(current_money: int, set_active: bool = false):
	if(equipment == null):
		print("no equipment could be found found for ", id)
		gold_text.modulate = insufficient_gold_color
		if(set_active):
			set_button_active(false)
		return
	#print("checking current money: ", current_money," against price ", equipment.get_cost())
	if(current_money >= equipment.get_cost()):
		gold_text.modulate = normal_gold_color
	else:
		gold_text.modulate = insufficient_gold_color
		print("insufficient golds")
	
	if(set_active):
		set_button_active(current_money >= equipment.get_cost())
	
func _on_mouse_entered():
	if(equipment != null):
		MouseDrag.display_gear_tooltip(equipment)

func _on_mouse_exited():
	if(equipment != null):
		MouseDrag.hide_gear_tooltip(equipment)
