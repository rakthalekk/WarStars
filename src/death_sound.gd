extends AudioStreamPlayer


func play_sound(sound):
	stream = sound
	play()
	
	await finished
	queue_free()
