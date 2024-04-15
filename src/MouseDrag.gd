extends Node

var dragObject: Drag_Icon
var currentOverlap: Drop_Area
var spawner

func can_drag()->bool:
	return dragObject == null

func set_drag(new_object: Drag_Icon, new_spawner: Node):
	
	if(!dragObject):
		dragObject = new_object
		print("start dragging new object ",new_object)
		new_object.z_index = 10
		get_parent().get_node("Fleet").add_child(dragObject);
		dragObject.move_to_front()
		spawner = new_spawner

func set_mouse_overlap(new_overlap: Drop_Area):
	currentOverlap = new_overlap

func _process(delta):
	if(dragObject != null):
		dragObject.global_position = get_viewport().get_mouse_position()
		#print("mouse draggging: ",dragObject.global_position)
	if(Input.is_action_just_released("ui_accept")):
		stop_dragging()

func stop_dragging():
	print("stop dragging")
	if(currentOverlap != null && dragObject != null):
		currentOverlap.drop_object(dragObject)
		dragObject.get_dropped()
	elif(dragObject != null):
		print("dropping on nothing")
		if(spawner != null && dragObject.is_army):
			print("dropping army on nothing")
			spawner.remove_from_army()
			spawner.queue_free()
		dragObject.get_dropped()

func remove_mouse_overlap(overlap: Drop_Area):
	if(currentOverlap == overlap):
		currentOverlap = null
