extends Control

func _ready():
	#while ($MarginContainer/HBoxContainer/CaptureContract.difficulty_stars == $MarginContainer/HBoxContainer/DefendContract.difficulty_stars and $MarginContainer/HBoxContainer/DefendContract.difficulty_stars == $MarginContainer/HBoxContainer/RouteContract.difficulty_stars):
		#print("Rerolling Difficulty RNG")
		#$MarginContainer/HBoxContainer/RouteContract._ready()
	pass

func _on_capture_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new($MarginContainer/HBoxContainer/Capture)
	print("Contract Type: " + GameManager.Contract_Type.find_key(GameManager.currentContract.type) + "\nDifficulty: " + str(GameManager.currentContract.difficulty_stars) + "\nReward: " + str(GameManager.currentContract.reward) + "\n")
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_defend_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new($MarginContainer/HBoxContainer/Defend)
	print("Contract Type: " + GameManager.Contract_Type.find_key(GameManager.currentContract.type) + "\nDifficulty: " + str(GameManager.currentContract.difficulty_stars) + "\nReward: " + str(GameManager.currentContract.reward) + "\n")
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_route_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new($MarginContainer/HBoxContainer/Route)
	print("Contract Type: " + GameManager.Contract_Type.find_key(GameManager.currentContract.type) + "\nDifficulty: " + str(GameManager.currentContract.difficulty_stars) + "\nReward: " + str(GameManager.currentContract.reward) + "\n")
	get_tree().change_scene_to_file("res://src/main.tscn")

