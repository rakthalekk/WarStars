class_name Rift_UI
extends Fleet_Structure_UI


@export var rift_script: Rift
@export var summon_panels: Array[Control]

func _ready():
	if(rift_script == null):
		return
	for i in summon_panels.size():
		summon_panels[i].visible = i < rift_script.capacity
		var can_buy = rift_script.can_summon(i)
		#mark as interactable only if you can afford its

func try_summon(id: int):
	if(rift_script.summon(id)):
		summon_panels[id].visible = false
