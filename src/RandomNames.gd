class_name RandomNames
extends Node
enum Contract_Type {CAPTURE, DEFEND, ROUTE}
var devList = ["Haley", "Faye", "Max", "Jack", "Charlie", "Landon", "Maverick", "Mitchell", "Tyler"]
var alienList = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://assets/AlienNames.txt", FileAccess.READ)
	while !file.eof_reached():
		alienList.append(file.get_line())
	file.close()
	alienList.remove_at(alienList.size() - 1)
	#print(Contract_Type.find_key(GameManager.currentContract.type))
	#print(GameManager.currentContract.difficulty_stars)
	#print(GameManager.currentContract.reward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var name = get_random_name()
	if (name != ""):
		print(name)

func get_random_name() -> String:
	if (alienList.size() == 0):
		return ""
	var rng = RandomNumberGenerator.new()
	if (rng.randi_range(1, 4192) == 1):
		if (devList.size() == 0):
			get_tree().change_scene_to_file("res://src/ErrorScene.tscn")
			return ""
		var devIndex = rng.randi_range(0, devList.size() - 1)
		var devElement = devList[devIndex]
		devList.remove_at(devIndex)
		return devElement
	var alienIndex = rng.randi_range(0, alienList.size() - 1)
	var alienElement = alienList[alienIndex]
	alienList.remove_at(alienIndex)
	return alienElement
