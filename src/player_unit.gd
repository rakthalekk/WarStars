class_name PlayerUnit
extends Unit


var hex_colors = [Color("8cff9b"), Color("ffaa6e"), Color("c37289"), Color("ffe091"), Color("ffa5d5"), Color("78fae6"), Color("b483ef"), Color("ff6675")]

func _ready():
	super()
	if(!assigned_sprites):
		select_sprites()


func activate_wait_buff():
	wait_buff = true
	effects_anim.play("wait_buff")


func select_sprites():
	var rand = randi_range(1, 11)
	$PathFollow2D/Head.texture = load("res://assets/PlayerUnits/UnitHeadType" + str(rand) +  ".png")
	if rand == 1:
		$PathFollow2D/Helmet.show()
	elif rand == 5:
		$PathFollow2D/Head.hframes = 2
		idle_anim = "head5_idle"
	
	var color = hex_colors.pick_random()
	$PathFollow2D/Head.modulate = color
	$PathFollow2D/Hands.modulate = color
	assigned_sprites = true

func set_sprites(head: Texture, color: Color):
	$PathFollow2D/Head.texture = head
	print("head type: " + head.get_path() + " to " + head.get_path().get_file())
	if head.get_path().get_file() == "UnitHeadType1.png":
		$PathFollow2D/Helmet.show()
	elif head.get_path().get_file() == "UnitHeadType5.png":
		$PathFollow2D/Head.hframes = 2
		idle_anim = "head5_idle"
	$PathFollow2D/Head.modulate = color
	$PathFollow2D/Hands.modulate = color
	assigned_sprites = true
