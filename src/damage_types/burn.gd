extends Status_Effect

# Called when the node enters the scene tree for the first time.
func _ready():
	type = EFFECT_TYPE.BURN
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	target.damage(magnitude)

func remove_effect():
	queue_free()
