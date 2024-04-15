class_name Healing_Vats_Selection_Panel
extends UI_Selection_Panel

@export var main_ui: Healing_Vats_UI
@export var person: Person
@export var id: int
@export var valid_funds: bool
@export var default_color: Color = Color.WHITE
@export var highlight_color: Color = Color.RED

func highlight(highlight: bool):
	if(highlight && !person && valid_funds && !MouseDrag.can_drag()):
		main_select_button.modulate = highlight_color
	else:
		main_select_button.modulate = default_color

func drop_person(dropped: Drag_Icon):
	print("person dropped. old person: ",person,", funds: ", valid_funds)
	var new_person = dropped.person_icon.person
	if(person == null && valid_funds):
		if(main_ui.try_heal(id, new_person)):
			main_image.texture = new_person.image
			dropped.person_icon.set_sleep()

func _can_drop_data(at_position, data):
	print("checking droppable in heal at ", at_position)
	return true#person == null

func _drop_data(at_position, data)->void:
	print ("dropping in heal")
	
	if(person == null && main_ui.healing_vats_script.try_add_person(id, data.person) && valid_funds):
		set_person(data.person)

func set_person(new_person: Person):
	person = new_person
	if(person != null):
		main_image.texture = person.image
		main_text.text = "Occupied"
	else:
		main_image.texture = default_image
		main_text.text = "Free"

func setup_money(current_money: int, set_active: bool = false)->void:
	print("setting up healing money: ")
	valid_funds = current_money >= main_ui.get_cost()
	gold_text.text = str(main_ui.get_cost())
	if(valid_funds):
		gold_text.modulate = normal_gold_color
	else:
		gold_text.modulate = insufficient_gold_color

func clear():
	person = null
	main_image.texture = default_image

