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


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	#type = Contract_Type.values()[rng.randi_range(0, Contract_Type.size() - 1)]
	#TODO: Replace with formula
	difficulty_stars = rng.randi_range(1, 5)
	#TODO: Replace with formula
	reward = rng.randi_range(1, 1000) * 1000
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
