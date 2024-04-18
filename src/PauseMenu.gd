extends TextureRect

@onready var button_click = get_parent().get_parent().get_node("ButtonClick") as AudioStreamPlayer


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
	button_click.play()


func _on_quit_pressed():
	button_click.play()
	get_tree().quit()
