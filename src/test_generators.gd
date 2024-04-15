extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	while i < 100:
		var unit = $PersonGenerator.generate_unit()
		print(unit.tier)
		print(unit.weapon1.name)
		print(unit.weapon2.name)
		if unit.weapon1.weapon_type == unit.weapon2.weapon_type:
			print("u fucked it")
			break


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
