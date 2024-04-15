class_name Rift_UI
extends Fleet_Structure_UI


@export var rift_script: Rift
@export var summon_panels: Array[Rift_Selection_Panel]

func open_ui():
	refresh()

func try_summon(id: int):
	if(rift_script.summon(id)):
		summon_panels[id].visible = false
		

func refresh():
	print("refreshing ui")
	if(rift_script == null):
		return
	for i in rift_script.capacity:
		summon_panels[i].setup(rift_script.get_summon(i))
	for i in summon_panels.size():
		summon_panels[i].visible = i < rift_script.capacity && rift_script.has_summon(i)
		
	check_prices()

func check_prices():
	for i in rift_script.capacity:
		var can_buy = rift_script.can_summon(i)
		summon_panels[i].set_button_active(can_buy)
		summon_panels[i].setup_money(rift_script.get_money())
