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

var capture_tile: Vector2:
	set(newCaptureTile):
		capture_tile = newCaptureTile
	get:
		return capture_tile
		
var combat_resource: PackedScene = preload("res://src/main.tscn")
var fleet_resource: PackedScene = preload("res://src/fleet.tscn")
var combat_scene: Node = null
var fleet: Node = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("res://assets/AlienNames.txt"):
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

func get_fleet():
	if fleet == null:
		fleet = fleet_resource.instantiate()
	return fleet
		
func get_combat_scene():
	if combat_scene == null:
		combat_scene = combat_resource.instantiate()
	return combat_scene

func load_fleet(units: Array[Unit] = []):
	for unit in units:
		unit.person_source.update_from_unit(unit)
	var main = get_tree().root.get_node("Main")
	get_tree().root.remove_child(combat_scene)
	get_tree().root.add_child(fleet)
		
func enter_combat(platoon: Array[Person_Icon]):
	for member in platoon:
		var unit = member.person.construct_unit()
		get_combat_scene().get_node("GameBoard").add_child(unit)
		
	get_tree().root.remove_child(fleet)
	get_tree().root.add_child(combat_scene)

# Generates a random name
func get_random_name() -> String:
	var rng = RandomNumberGenerator.new()
	if (rng.randi_range(1, 4192) == 1):
		if (devList.size() == 0):
			get_tree().change_scene_to_file("res://src/ErrorScene.tscn")
			return ""
		var devIndex = rng.randi_range(0, devList.size() - 1)
		var devElement = devList[devIndex]
		devList.remove_at(devIndex)
		return devElement
	if (alienList.size() == 0):
		return ""
	var alienIndex = rng.randi_range(0, alienList.size() - 1)
	var alienElement = alienList[alienIndex]
	alienList.remove_at(alienIndex)
	return alienElement
	
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
		
