extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		print('hi')
		if !get_tree().paused:
			show()
			$BackToGame.grab_focus()
			get_tree().paused = true
		else:
			hide()
			get_tree().paused = false


func _on_back_to_game_pressed():
	hide()
	get_tree().paused = false


func _on_quit_pressed():
	get_tree().quit()
