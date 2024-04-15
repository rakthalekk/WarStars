extends Control

@export var heal_vat_selection: Healing_Vats_Selection_Panel

func _can_drop_data(at_position, data):
	print("checking droppable, ",data.name,", ",self.name)
	return heal_vat_selection._can_drop_data(at_position, data)
	return true

func _drop_data(at_position, data):
	print ("dropping ",data)
	heal_vat_selection._drop_data(at_position,data)


