extends Node

var dragObject: Drag_Icon
var currentOverlap: Drop_Area
var spawner
var player_tooltip
var hover_person
var weapon_tooltip
var hover_weapon
var gear_tooltip
var hover_gear

func _ready():
	player_tooltip = %"Unit Popup"
	weapon_tooltip = %"EquipmentPopup"
	gear_tooltip = %"Gear Popup"
	#player_tooltip.reparent(get_parent().get_node("Fleet/FleetUI"))
	#player_tooltip.move_to_front()

func can_drag()->bool:
	return dragObject == null

func set_drag(new_object: Drag_Icon, new_spawner: Node):
	
	if(!dragObject):
		hide_tooltips()
		dragObject = new_object
		print("start dragging new object ",new_object)
		new_object.z_index = 10
		get_parent().get_node("Fleet/FleetUI").add_child(dragObject);
		dragObject.move_to_front()
		spawner = new_spawner

func set_mouse_overlap(new_overlap: Drop_Area):
	currentOverlap = new_overlap

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	player_tooltip.position = mouse_pos - Vector2(80,0)
	weapon_tooltip.position = mouse_pos - Vector2(80,0)
	gear_tooltip.position = mouse_pos - Vector2(80,0)
	if(dragObject != null):
		dragObject.global_position = mouse_pos
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
	
	if(hover_person != null):
		display_person_tooltip(hover_person)
	elif(hover_weapon != null):
		display_weapon_tooltip(hover_weapon)
	elif(hover_gear != null):
		display_gear_tooltip(hover_gear)

func hide_tooltips():
	player_tooltip.visible = false
	weapon_tooltip.visible = false
	gear_tooltip.visible = false

func remove_mouse_overlap(overlap: Drop_Area):
	if(currentOverlap == overlap):
		currentOverlap = null

func display_person_tooltip(person: Person):
	hover_person = person
	if(dragObject != null):
		return
	hide_tooltips()
	player_tooltip.visible = true
	player_tooltip.get_node("Name").text = person.name
	player_tooltip.get_node("Tier").text = "Tier " + str(person.tier)
	player_tooltip.get_node("HP").text = "HP: " + str(person.health) + "/" + str(person.max_health)
	player_tooltip.get_node("Movement").text = "Move: " + str(person.speed)
	player_tooltip.reparent(get_parent().get_node("Fleet/FleetUI"))
	player_tooltip.move_to_front()

func display_weapon_tooltip(weapon: Weapon):
	hover_weapon = weapon
	if(dragObject != null):
		return
	hide_tooltips()
	weapon_tooltip.visible = true
	weapon_tooltip.get_node("Name").text = weapon.name
	match(weapon.weapon_type):
		Equipment_Generator.Weapon_Type.RIFLE:
			weapon_tooltip.get_node("Type").text = "Type: Rifle"
		Equipment_Generator.Weapon_Type.MELEE:
			weapon_tooltip.get_node("Type").text = "Type: Melee"
		Equipment_Generator.Weapon_Type.PISTOL:
			weapon_tooltip.get_node("Type").text = "Type: Sidearm"
		Equipment_Generator.Weapon_Type.SHOTGUN:
			weapon_tooltip.get_node("Type").text = "Type: Shotgun"
	weapon_tooltip.get_node("Range").text = "Range: " + str(weapon.range)
	weapon_tooltip.get_node("Damage").text = "Dmg: " + str(weapon.damage)
	weapon_tooltip.get_node("Heat").text = "Heat: " + str(weapon.heat_max)
	weapon_tooltip.reparent(get_parent().get_node("Fleet/FleetUI"))
	weapon_tooltip.move_to_front()

func display_gear_tooltip(gear: Gear):
	hover_gear = gear
	if(dragObject != null):
		return
	hide_tooltips()
	gear_tooltip.visible = true
	gear_tooltip.get_node("Name").text = gear.name
	gear_tooltip.get_node("Description").text = gear.equipment_description
	gear_tooltip.reparent(get_parent().get_node("Fleet/FleetUI"))
	gear_tooltip.move_to_front()

func hide_person_tooltip(person: Person):
	if(hover_person == person):
		player_tooltip.visible = false
		hover_person = null

func hide_weapon_tooltip(weapon: Weapon):
	if(hover_weapon == weapon):
		weapon_tooltip.visible = false
		hover_weapon = null

func hide_gear_tooltip(gear: Gear):
	if(hover_gear == gear):
		gear_tooltip.visible = false
		hover_gear = null
