class_name RandomNames
extends Node

#var devList = ["Haley", "Faye", "Max", "Jack", "Charlie", "Landon", "Maverick", "Mitchell", "Tyler"]
#var alienList = []
# Called when the node enters the scene tree for the first time.
func _ready():
	#await get_tree().create_timer(0.5).timeout
	#get_tree().change_scene_to_file("res://src/ContractUI.tscn")
	pass
	#print(Contract_Type.find_key(GameManager.currentContract.type))
	#print(GameManager.currentContract.difficulty_stars)
	#print(GameManager.currentContract.reward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var name = get_random_name()
	#if (name != ""):
		#print(name)
	pass

func get_random_name() -> String:
	var rng = RandomNumberGenerator.new()
	if (rng.randi_range(1, 4192) == 1):
		if (GameManager.devList.size() == 0):
			get_tree().change_scene_to_file("res://src/ErrorScene.tscn")
			return ""
		var devIndex = rng.randi_range(0, GameManager.devList.size() - 1)
		var devElement = GameManager.devList[devIndex]
		GameManager.devList.remove_at(devIndex)
		return devElement
	if (GameManager.alienList.size() == 0):
		return ""
	var alienIndex = rng.randi_range(0, GameManager.alienList.size() - 1)
	var alienElement = GameManager.alienList[alienIndex]
	GameManager.alienList.remove_at(alienIndex)
	return alienElement
