class_name Black_Market_UI
extends Fleet_Structure_UI

@export var black_market_script: Black_Market
@export var purchase_panels: Array[Control]

func _ready():
	refresh()

func try_purchase(id: int):
	if(black_market_script.purchase(id)):
		purchase_panels[id].visible = false
		

func refresh():
	if(black_market_script == null):
		return
	for i in purchase_panels.size():
		purchase_panels[i].visible = i < black_market_script.capacity
		var can_buy = black_market_script.can_summon(i)
		#mark as interactable only if you can afford its
