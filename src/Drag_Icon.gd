class_name Drag_Icon
extends TextureRect

var dragging: bool = false
var is_army: bool = false
var person_icon: Person_Icon
var gear_icon: Equip_Icon

func get_dropped():
	queue_free()
