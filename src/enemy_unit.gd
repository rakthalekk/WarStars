class_name EnemyUnit
extends Unit


func _ready():
	super()
	select_sprite(tier)


func select_sprite(tier: int):
	$PathFollow2D/Sprite.texture = load("res://assets/EnemyUnits/Tier" + str(tier) +  "Enemy.png")


func set_sprites(head: Texture, color: Color):
	$PathFollow2D/Sprite.texture = head
	assigned_sprites = true
