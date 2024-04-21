class_name Healing_Vats
extends Fleet_Structure

@export var vats: Array[Person]
@export var vats_ui: Healing_Vats_UI
@export var cost: int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in capacity:
		vats.append(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func upgrade_capacity():
	super.upgrade_capacity()
	vats.append(null)
	vats_ui.refresh()
	




func can_use_vat(id: int):
	return vats[id] == null

func get_vat_user(id: int):
	return vats[id]

func can_afford_heal():
	return manager.get_current_money() >= cost

func refresh():
	for id in vats.size():
		if(vats[id] != null):
			#restore all health and ensure is no longer resting
			vats[id] = null
			vats[id].health = vats[id].max_health
			vats[id].resting = false
	vats_ui.refresh()

func try_add_person(id: int, person: Person)-> bool:
	if vats[id] != null:
		return false
	
	#don't let player add person with full health
	
	if(person.health == person.max_health || person.resting):
		return false
	
	vats[id] = person
	
	vats_ui.refresh()
	#mark person as resting
	person.resting = true
	manager.reserves.update_unit_visual(person)
	AudioManager.play_purchase()
	return true

