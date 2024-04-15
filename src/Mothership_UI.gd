class_name Mothership_UI
extends Fleet_Structure_UI

@export var mothership_script: Mothership
@export var current_platoon: Array[Person_Icon]
@export var default_color: Color = Color.WHITE
@export var highlight_color: Color = Color.LIGHT_BLUE
@export var army_container: ColorRect
@export var base_icon: Person_Icon
@export var icon_holder: Control
@export var capacity_label: Label

func open_ui():
	refresh_visuals()

func refresh():
	for item in current_platoon:
		item.queue_free()
	current_platoon.clear()
	for unit in mothership_script.troops:
		spawn_new_soldier(unit)
	refresh_visuals()

func refresh_visuals():
	current_platoon = current_platoon.filter(func(unit): return unit != null && unit.person != null && unit.person.health > 0)
	for unit in current_platoon:
		unit.check_visuals()
	update_label()
	#update contracts
	#update visuals for army area

func drop_person(dropped: Drag_Icon)->bool:
	#print("person dropped. old person: ",person,", funds: ", valid_funds)
	var new_person = dropped.person_icon.person
	if(mothership_script.try_add_person(new_person)):
		spawn_new_soldier(dropped.person_icon.person)
		return true
	return false

func highlight_army(highlight: bool):
	if(highlight && !MouseDrag.can_drag() && !MouseDrag.dragObject.person_icon.person.resting && !MouseDrag.dragObject.person_icon.person.fighting):
		army_container.modulate = highlight_color
	else:
		army_container.modulate = default_color
		

func remove_unit(person: Person):
	#current_platoon.erase(person)
	mothership_script.remove_person(person)
	current_platoon = current_platoon.filter(func(unit):return unit != null)
	update_label()



func spawn_new_soldier(person: Person):
	var new_icon:Person_Icon = base_icon.duplicate()
	new_icon.set_person(person)
	new_icon.visible = true
	current_platoon.append(new_icon)
	icon_holder.add_child(new_icon)
	print("new icon: ", new_icon)
	update_label()

func update_label():
	capacity_label.text = str(mothership_script.troops.size()) + "/" + str(mothership_script.capacity)
