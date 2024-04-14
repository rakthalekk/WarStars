class_name Party_Menu
extends Control


@export var party_icons: Array[Person_Icon]
@export var icon_holder: VBoxContainer
@export var base_icon: Person_Icon

func add_new_party_member(person: Person):
	var new_icon:Person_Icon = base_icon.duplicate()
	new_icon.set_person(person)
	new_icon.visible = true
	party_icons.append(new_icon)
	icon_holder.add_child(new_icon)
	print("new icon: ", new_icon)

func remove_party_member(person: Person):
	if(!party_icons.find(person)):
		return
	party_icons.erase(person)
	icon_holder.remove_child(person)
	person.queue_free()
