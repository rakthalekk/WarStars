class_name Accel_Effect
extends Status_Effect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _apply_effect():
	target.move_range += magnitude
	
func _remove_effect():
	target.move_range = original_stat
	
func _save_stat():
	original_stat = target.move_range
