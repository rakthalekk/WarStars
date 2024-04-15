class_name Healing_Vats
extends Fleet_Structure

@export var vats: Array[Person]
@export var vats_ui: Healing_Vats_UI

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in capacity:
		vats.append(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func can_use_vat(id: int):
	return vats[id] == null

func refresh():
	for id in vats.size():
		if(vats[id] != null):
			#restore all health and ensure is no longer resting
			vats[id] = null
	vats_ui.refresh()

func try_add_person(id: int, person: Person)-> bool:
	if vats[id] != null:
		return false
	
	#don't let player add person with full health
	
	vats[id] = person;
	#mark person as resting
	
	return true
