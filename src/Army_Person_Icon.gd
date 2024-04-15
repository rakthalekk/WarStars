class_name Army_Person_Icon
extends Person_Icon

@export var mothership_ui: Mothership_UI

func remove_from_army():
	print("trying to remove from army")
	if(mothership_ui):
		print("removing from army")
		person.fighting = false
		mothership_ui.remove_unit(person)


