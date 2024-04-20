class_name Person_Image_Picker
extends Node

@export var images: Array[Texture]
@export var alien_color: Array[Color]

func get_image()->Texture:
	return images.pick_random()

func get_color()->Color:
	return alien_color.pick_random()
