class_name Rift_UI
extends Fleet_Structure_UI


@export var rift_script: Rift
@export var summon_panels: Array[Rift_Selection_Panel]

func get_structure()->Fleet_Structure:
	return rift_script

func open_ui():
	super.open_ui()
	GameManager.help_menu_title = "The Rift"
	GameManager.help_menu_description = "New warriors may be summoned for a fee. These will be added to your reserves on the right. Double-click a warrior to look at their information."
	refresh()

func try_summon(id: int):
	if(rift_script.summon(id)):
		update_money_text()
		return true
		#summon_panels[id].visible = false
	return false

func refresh():
	print("refreshing ui")
	if(rift_script == null):
		return
	for i in rift_script.capacity:
		summon_panels[i].setup(rift_script.get_summon(i))
	for i in summon_panels.size():
		summon_panels[i].visible = i < rift_script.capacity
		
	check_prices()

func check_prices():
	for i in rift_script.capacity:
		var can_buy = rift_script.can_summon(i)
		summon_panels[i].set_button_active(can_buy)
		summon_panels[i].setup_money(rift_script.get_money())

