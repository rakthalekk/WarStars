extends Unit


var hex_colors = [Color("8cff9b"), Color("ffaa6e"), Color("c37289"), Color("ffe091"), Color("ffa5d5")]

func _ready():
	super()
	select_sprites()


func select_sprites():
	var rand = randi_range(1, 7)
	$PathFollow2D/Head.texture = load("res://assets/PlayerUnits/UnitHeadType" + str(rand) +  ".png")
	if rand == 1:
		$PathFollow2D/Helmet.show()
	elif rand == 5:
		$PathFollow2D/Head.hframes = 2
		$AnimationPlayer.play("head5_idle")
	
	var color = hex_colors.pick_random()
	$PathFollow2D/Head.modulate = color
	$PathFollow2D/Hands.modulate = color
