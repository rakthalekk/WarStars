class_name Mothership_Unit_Capacity_UI
extends Control

@export var fill_sections: Array[TextureRect]
@export var fill_end_1: TextureRect
@export var fill_end_2: TextureRect
var current_fill_end: TextureRect
@export var tier_1_sections: Array[TextureRect]
@export var tier_1_end: TextureRect
@export var tier_2_sections: Array[TextureRect]
@export var tier_2_end: TextureRect
@export var tier_3_sections: Array[TextureRect]
@export var tier_3_end: TextureRect

var current_tier: int

func reset():
	for i in fill_sections:
		i.visible = false
	for i in tier_1_sections:
		i.visible = false
	for i in tier_2_sections:
		i.visible = false
	for i in tier_3_sections:
		i.visible = false
	tier_1_end.visible = false
	tier_2_end.visible = false
	tier_3_end.visible = false
	fill_end_1.visible = false
	fill_end_2.visible = false
	current_fill_end = null

func set_tier(tier: int):
	current_tier = tier
	for i in tier_1_sections:
		i.visible = true
	if(tier == 1):
		tier_1_end.visible = true
		current_fill_end = fill_end_1
		return
	for i in tier_2_sections:
		i.visible = true
	if(tier == 2):
		tier_2_end.visible = true
		current_fill_end = fill_end_2
		return
	for i in tier_3_sections:
		i.visible = true
	tier_3_end.visible = true

func display_capacity(current_number: int, capacity: int):
	for i in capacity:
		if(current_tier == 1 && i == 7):
			fill_end_1.visible = true
			fill_sections[i].visible = false
		elif(current_tier == 2 && i == 11):
			fill_end_2.visible = true
			fill_sections[i].visible = false
		else:
			fill_sections[i].visible = i < current_number
			

		
