class_name Healing_Vats_UI
extends Fleet_Structure_UI

@export var healing_vats_script: Healing_Vats
@export var heal_panels: Array[Control]

func get_structure()->Fleet_Structure:
	return healing_vats_script

func open_ui():
	super.open_ui()
	refresh()

func _ready():
	refresh()

func try_heal(id: int, person: Person)->bool:
	print("trying to heal")
	var success = healing_vats_script.try_add_person(id, person)
	if(success):
		update_money_text()
	return success

		
func refresh():
	print("refreshing ui")
	if(healing_vats_script == null):
		return
	for i in healing_vats_script.capacity:
		heal_panels[i].set_person(healing_vats_script.get_vat_user(i))
	for i in heal_panels.size():
		heal_panels[i].visible = i < healing_vats_script.capacity
		
	check_prices()

func check_prices():
	print("checking healing prices")
	for i in healing_vats_script.capacity:
		var can_buy = healing_vats_script.can_afford_heal()
		heal_panels[i].setup_money(healing_vats_script.get_money())

func get_cost():
	return healing_vats_script.cost


