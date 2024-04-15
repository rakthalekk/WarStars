extends Node

var dragObject: Drag_Icon
var currentOverlap: Drop_Area

func can_drag()->bool:
	return dragObject == null

func set_drag(new_object: Drag_Icon):
	
	if(!dragObject):
		dragObject = new_object
		print("start dragging new object ",new_object)
		new_object.z_index = 10
		get_parent().get_node("Fleet").add_child(dragObject);
		dragObject.move_to_front()
		

func set_mouse_overlap(new_overlap: Drop_Area):
	currentOverlap = new_overlap

func _process(delta):
	if(dragObject != null):
		dragObject.global_position = get_viewport().get_mouse_position()
		#print("mouse draggging: ",dragObject.global_position)
	if(Input.is_action_just_released("click")):
		stop_dragging()

func stop_dragging():
	print("stop dragging")
	if(currentOverlap != null && dragObject != null):
		currentOverlap.drop_object(dragObject)
		dragObject.get_dropped()
	elif(dragObject != null):
		dragObject.get_dropped()

func remove_mouse_overlap(overlap: Drop_Area):
	if(currentOverlap == overlap):
		currentOverlap = null
