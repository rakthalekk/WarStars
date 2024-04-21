class_name Party_Menu
extends Control


@export var party_icons: Array[Person_Icon]
@export var icon_holder: VBoxContainer
@export var base_icon: Person_Icon

func add_new_party_member(person: Person):
	var new_icon:Person_Icon = base_icon.duplicate(DUPLICATE_SIGNALS + DUPLICATE_GROUPS + DUPLICATE_SCRIPTS)
	icon_holder.add_child(new_icon)
	new_icon.setup()
	new_icon.set_person(person)
	new_icon.visible = true
	new_icon.set_active()
	party_icons.append(new_icon)
	
	print("new icon: ", new_icon)

func remove_party_member(person: Person):
	if(!party_icons.find(person)):
		return
	party_icons.erase(person)
	icon_holder.remove_child(person)
	person.queue_free()

func update_visual(person: Person):
	print("trying to update visual")
	for icon in party_icons:
		if(icon.person == person):
			icon.check_visuals()
			return
	icon_holder.check_visuals(person)
