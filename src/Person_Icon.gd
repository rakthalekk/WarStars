class_name Person_Icon
extends Control

@export var icon: TextureRect
@export var drag_icon: Drag_Icon
@export var person: Person
@export var sleep_color: Color = Color.DIM_GRAY
@export var sleep_icon: Control
@export var default_color: Color = Color.WHITE
@export var warband_color: Color = Color.FIREBRICK
@export var is_army: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func check_visuals():
	if(person.resting):
		set_sleep()
	elif(person.fighting):
		set_war()
	else:
		set_active()

func set_active():
	icon.modulate = default_color
	sleep_icon.visible = true

func set_sleep():
	icon.modulate = sleep_color
	sleep_icon.visible = true

func set_war():
	icon.modulate = warband_color

func set_person(new_person:Person):
	person=new_person;
	if(new_person.image != null):
		icon.texture = new_person.image

#func _get_drag_data(at_position):
#	print("start dragging")
#	set_drag_preview(_get_preview_control(at_position))
#	return self

func _on_item_dropped_on_target():
	pass

#func _get_preview_control(at_position)-> Control:
	#var preview = TextureRect.new()
	#preview.texture = icon2.texture
	#var prev_color = drag_color
	#prev_color.a = .5
	#preview.modulate = prev_color
	#preview.global_position = at_position
	#preview.size.x = 32
	#preview.size.y = 32
	#print("using preview ", preview.texture)
	#return preview

func _can_drop(pos,data):
	print("checking droppable")
	mouse_filter = Control.MOUSE_FILTER_PASS #<---- This bit makes it droppable
	return true


func _on_gui_input(event):
	#print("input recieved")
	if event is InputEventScreenDrag:
		
		if(!MouseDrag.can_drag()):
			return
		print("dragged")
		var drag = drag_icon.duplicate()
		drag.person_icon = self
		drag.modulate.a = .5
		drag.is_army = is_army
		MouseDrag.set_drag(drag, self)
		#add_child(drag)
		#drag.move_to_front()




