class_name Drag_Icon
extends TextureRect

var dragging: bool = false
var person_icon: Person_Icon

func get_dropped():
	queue_free()
