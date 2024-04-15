class_name Healing_Drop_Area
extends Drop_Area

@export var heal_vat: Healing_Vats_Selection_Panel

func start_overlap():
	super.start_overlap()
	heal_vat.highlight(true)

func end_overlap():
	super.end_overlap()
	heal_vat.highlight(false)

func drop_object(obj: Drag_Icon)->bool:
	heal_vat.drop_person(obj)
	return true
