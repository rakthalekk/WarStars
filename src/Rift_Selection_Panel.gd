class_name Rift_Selection_Panel
extends UI_Selection_Panel

@export var rift_UI: Rift_UI
@export var id: int
@export var person: Person

func on_button_click():
	rift_UI.try_summon(id)
	
func setup(new_person):
	if(new_person == null):
		print("no person to setup")
		return
	person = new_person
	main_text.text = person.name
	price = person.price
	gold_text.text = str(price)
	main_image.texture = person.image
	
	

func set_button_active(active: bool):
	main_select_button.disabled = !active

func setup_money(current_money: int, set_active: bool = false):
	if(person == null):
		print("no person could be found found for ", id)
	
	#print("checking current money: ", current_money," against price ", person.price)
	if(current_money >= person.price):
		gold_text.modulate = normal_gold_color
	else:
		gold_text.modulate = insufficient_gold_color
	
	if(set_active):
		set_button_active(current_money >= person.price)
	
