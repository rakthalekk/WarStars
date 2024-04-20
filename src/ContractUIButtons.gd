extends Control

@export var mothership_ui: Mothership_UI

func _ready():
	#while ($MarginContainer/HBoxContainer/CaptureContract.difficulty_stars == $MarginContainer/HBoxContainer/DefendContract.difficulty_stars and $MarginContainer/HBoxContainer/DefendContract.difficulty_stars == $MarginContainer/HBoxContainer/RouteContract.difficulty_stars):
		#print("Rerolling Difficulty RNG")
		#$MarginContainer/HBoxContainer/RouteContract._ready()
	pass

func _on_capture_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new()
	GameManager.currentContract.initialize_by_contract($MarginContainer/HBoxContainer/CaptureContract)
	print("Contract Type: " + GameManager.Contract_Type.find_key(GameManager.currentContract.type) + "\nDifficulty: " + str(GameManager.currentContract.difficulty_stars) + "\nReward: " + str(GameManager.currentContract.reward) + "\n")
	GameManager.enter_combat(mothership_ui.current_platoon)


func _on_defend_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new()
	GameManager.currentContract.initialize_by_contract($MarginContainer/HBoxContainer/DefendContract)
	print("Contract Type: " + GameManager.Contract_Type.find_key(GameManager.currentContract.type) + "\nDifficulty: " + str(GameManager.currentContract.difficulty_stars) + "\nReward: " + str(GameManager.currentContract.reward) + "\n")
	GameManager.enter_combat(mothership_ui.current_platoon)


func _on_route_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new()
	GameManager.currentContract.initialize_by_contract($MarginContainer/HBoxContainer/RouteContract)
	print("Contract Type: " + GameManager.Contract_Type.find_key(GameManager.currentContract.type) + "\nDifficulty: " + str(GameManager.currentContract.difficulty_stars) + "\nReward: " + str(GameManager.currentContract.reward) + "\n")
	GameManager.enter_combat(mothership_ui.current_platoon)

