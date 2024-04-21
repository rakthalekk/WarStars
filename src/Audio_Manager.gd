extends Node


@export var click_player: AudioStreamPlayer
@export var purchase_player: AudioStreamPlayer
@export var click_sound = preload("res://assets/sounds/Button Click.mp3")
@export var purchase_sounds = [preload("res://assets/sounds/Purchase SFX 1.mp3"), preload("res://assets/sounds/Purchase SFX 2.mp3"), preload("res://assets/sounds/Purchase SFX 3.mp3")]

func _ready():
	click_player.stream = click_sound

func play_click():
	print("playing click noise")
	click_player.play()

func play_purchase():
	print("playing purchase noise")
	purchase_player.stream = purchase_sounds.pick_random()
	purchase_player.play()
