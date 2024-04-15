extends Node

enum Contract_Type {CAPTURE, DEFEND, ROUTE}
# Stores the contract difficulties in a dictionary for rerolling purposes stored in the order of the type
var contractDifficulties = {Contract_Type.CAPTURE: 1, Contract_Type.DEFEND: 1, Contract_Type.ROUTE: 1}
# List of the "shiny" names
var devList = ["Haley", "Faye", "Max", "Jack", "Charlie", "Landon", "Maverick", "Mitchell", "Tyler"]:
	get:
		return devList
# List of the alien names read from a file
var alienList = []:
	get:
		return alienList
# Contract Data structure
var currentContract: ContractData = null:
	set(newContract):
		currentContract = newContract
	get:
		return currentContract

var current_turn: int = 0:
	get:
		return current_turn

var chapter_complete: bool = false:
	set(newChapterComplete):
		chapter_complete = newChapterComplete
	get:
		return chapter_complete

func incrementTurns():
	current_turn += 1
	
func resetTurns():
	current_turn = 0

var controller = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://assets/AlienNames.txt", FileAccess.READ)
	while !file.eof_reached():
		alienList.append(file.get_line())
	file.close()
	alienList.remove_at(alienList.size() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func removeDev(devIndex: int):
	devList.remove_at(devIndex)
	
func removeAlien(alienIndex: int):
	alienList.remove_at(alienIndex)
# Adds contract difficulty to the dictionary of difficulties with the index of the type of contract and value of the difficulty 
func addContractDifficulty(index: int, value: int):
	contractDifficulties[index] = value
	
# Inner class storing the contract data
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
	var defend_turns: int:
		get:
			return defend_turns
	
	func _init(newContract: Contract):
		type = newContract.type
		difficulty_stars = newContract.difficulty_stars
		reward = newContract.reward
		defend_turns = newContract.defend_turns
