class_name Army_Drop_Area
extends Drop_Area


@export var mothership: Mothership_UI

func start_overlap():
	super.start_overlap()
	mothership.highlight_army(true)

func end_overlap():
	super.end_overlap()
	mothership.highlight_army(false)

func drop_object(obj: Drag_Icon)->bool:
	return mothership.drop_person(obj)
