class_name Contract
extends Node


@export var type: GameManager.Contract_Type:
	get:
		return type
@export var difficulty_stars: int = 1:
	get:
		return difficulty_stars
@export var reward: int:
	get:
		return reward
@export var defend_turns: int = 2:
	get:
		return defend_turns


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.resetTurns()
	var rng = RandomNumberGenerator.new()
	#type = Contract_Type.values()[rng.randi_range(0, Contract_Type.size() - 1)]
	difficulty_stars = rng.randi_range(1, 5)
	GameManager.addContractDifficulty(type, difficulty_stars)
	match type:
		GameManager.Contract_Type.ROUTE:
			while (GameManager.contractDifficulties[GameManager.Contract_Type.CAPTURE] == difficulty_stars and GameManager.contractDifficulties[GameManager.Contract_Type.DEFEND] == difficulty_stars):
				print("Rerolling Difficulty RNG\n")
				difficulty_stars = rng.randi_range(1, 5)
				GameManager.addContractDifficulty(type, difficulty_stars)
		GameManager.Contract_Type.DEFEND:
			#TODO formula for defend turns
			pass
	match difficulty_stars:
		1:
			reward = rng.randi_range(20, 30) * 10
		2:
			reward = rng.randi_range(40, 55) * 10
		3:
			reward = rng.randi_range(70, 110) * 10
		4:
			reward = rng.randi_range(120, 160) * 10
		5:
			reward = rng.randi_range(200, 220) * 10
	#print(Contract_Type.find_key(type))
	#print(difficulty_stars)
	#print(reward)
	# Writes to contract button labels
	if (has_node("DifficultyLabel") && has_node("RewardLabel")):
		$DifficultyLabel.text = "Difficulty: " + str(difficulty_stars) + "/5"
		$RewardLabel.text = "Reward: " + str(reward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

