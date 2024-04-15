class_name Burn
extends Status_Effect

# Called when the node enters the scene tree for the first time.
func _init(effect_level: int = 1, effect_duration: int = 1):
	magnitude = effect_level
	duration = effect_duration + 1
	applied_every_turn = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _apply_effect():
	target.damage(magnitude)
	
func _remove_effect():
	pass
	
func _save_stat():
	pass
