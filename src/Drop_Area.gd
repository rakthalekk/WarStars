class_name Drop_Area
extends Control

@export var heal_vat_selection: Healing_Vats_Selection_Panel

func start_overlap():
	print("overlap")
	MouseDrag.set_mouse_overlap(self)
	heal_vat_selection.highlight(true)

func end_overlap():
	print("stop overlap")
	MouseDrag.remove_mouse_overlap(self)
	heal_vat_selection.highlight(false)

func drop_object(obj: Drag_Icon):
	heal_vat_selection.drop_person(obj)


