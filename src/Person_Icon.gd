class_name Person_Icon
extends Control

@export var icon: TextureRect
@export var drag_icon: Drag_Icon
@export var person: Person
@export var highlight_icon: TextureRect
@export var sleep_color: Color = Color.DIM_GRAY
@export var sleep_icon: Control
@export var default_color: Color = Color.WHITE
@export var warband_color: Color = Color.FIREBRICK
@export var is_army: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup():
	icon = get_node("Icon")
	drag_icon = get_node("Drag_Icon")
	highlight_icon = get_node("Highlight")

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
	highlight_icon.modulate = default_color
	sleep_icon.visible = false

func set_sleep():
	highlight_icon.modulate = sleep_color
	sleep_icon.visible = true

func set_war():
	highlight_icon.modulate = warband_color
	sleep_icon.visible = false

func set_person(new_person:Person):
	person=new_person;
	if(new_person.image != null):
		icon.texture = new_person.image
		icon.modulate = new_person.color
		drag_icon.texture = new_person.image
		drag_icon.modulate = new_person.color
	else:
		print("person texture is null")

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
	if event is InputEventMouseButton && event.is_double_click():
		AudioManager.play_click()
		InventoryMenuListener.open_inventory(person)
		return
	elif event is InputEventMouseButton && event.is_pressed():
		AudioManager.play_click()
		InventoryMenuListener.open_inventory(person, true)
		return
	#print("input recieved")
	if event is InputEventScreenDrag:
		
		if(!MouseDrag.can_drag()):
			return
		print("dragged")
		var drag = drag_icon.duplicate()
		drag.person_icon = self
		drag.modulate.a = .5
		drag.visible = true
		drag.is_army = is_army
		MouseDrag.set_drag(drag, self)
		#add_child(drag)
		#drag.move_to_front()






func _on_mouse_entered():
	MouseDrag.display_person_tooltip(person)

func _on_mouse_exited():
	MouseDrag.hide_person_tooltip(person)
