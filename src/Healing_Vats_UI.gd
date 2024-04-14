class_name Healing_Vats_UI
extends Fleet_Structure_UI

@export var healing_vats_script: Healing_Vats
@export var heal_panels: Array[Control]

func _ready():
	refresh()

func try_heal(id: int, person: Person):
	if(healing_vats_script.try_add_person(id, person)):
		heal_panels[id].visible = false
		

func refresh():
	if(healing_vats_script == null):
		return
	for i in heal_panels.size():
		heal_panels[i].visible = i < healing_vats_script.capacity
		var can_use_vat = healing_vats_script.can_use_vat(i)
		#mark as interactable only if you can afford its

