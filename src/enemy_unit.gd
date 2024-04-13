extends Unit


func _ready():
	super()
	select_sprite(tier)


func select_sprite(tier: int):
	$PathFollow2D/Head.texture = load("res://assets/EnemyUnits/Tier" + str(tier) +  "Enemy.png")
