class_name Person_Icon
extends Control

@export var icon: TextureRect
@export var person: Person

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func set_person(new_person:Person):
	person=new_person;
	icon.texture = new_person.image
