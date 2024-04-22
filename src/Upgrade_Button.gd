class_name Upgrade_Button
extends Button

@export var ship: Fleet_Structure_UI
@export var cost: int
@export var tier: int
@export var cost_label: Label
@export var tier_label: Label
@export var money_icon: TextureRect
@export var display_label: Label
@export var max_level_label: Label
@export var normal_gold_color: Color = Color.GOLD
@export var insufficient_gold_color: Color = Color.RED

func setup(next_cost: int, current_tier: int):
	cost = next_cost
	tier = current_tier
	tier_label.text = "tier "+str(tier)
	cost_label.text = str(next_cost)
	if(next_cost <= ship.main_ui.reserves.money):
		cost_label.modulate = normal_gold_color
	else:
		cost_label.modulate = insufficient_gold_color
	
	if(tier == 3):
		cost_label.visible = false
		money_icon.visible = false
		display_label.visible = false
		max_level_label.visible = true
		disabled = true

func refresh():
	print("refreshing upgrade: ",ship.get_structure().get_cost(),", ",ship.get_structure().level)
	setup(ship.get_structure().get_cost(),ship.get_structure().level)

func _ready():
	refresh()

func press_button():
	print("button pressed: ",ship.get_structure().can_upgrade())
	AudioManager.play_click()
	if(ship.get_structure().can_upgrade()):
		ship.get_structure().upgrade_capacity()
		refresh()
		AudioManager.play_purchase()
