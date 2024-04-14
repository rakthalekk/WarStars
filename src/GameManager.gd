extends Node

enum Contract_Type {CAPTURE, DEFEND, ROUTE}

class ContractData:

	var type: Contract_Type:
		get:
			return type
	var difficulty_stars: int = 1:
		get:
			return difficulty_stars
	var reward: int:
		get:
			return reward
	
	func _init(newContract: Contract):
		type = newContract.type
		difficulty_stars = newContract.difficulty_stars
		reward = newContract.reward
	
var currentContract: ContractData = null:
	set(newContract):
		currentContract = newContract
	get:
		return currentContract
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

