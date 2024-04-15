class_name Drop_Area
extends Control

func start_overlap():
	print("overlap")
	MouseDrag.set_mouse_overlap(self)

func end_overlap():
	print("stop overlap")
	MouseDrag.remove_mouse_overlap(self)

func drop_object(obj: Drag_Icon)->bool:
	print("dropping")
	return true


