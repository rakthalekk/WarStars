class_name Burn
extends Status_Effect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _apply_effect():
	target.damage(magnitude)
	
func _remove_effect():
	pass
	
func _save_stat():
	pass
