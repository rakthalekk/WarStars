extends Node

enum Contract_Type {CAPTURE, DEFEND, ROUTE}
# Stores the contract difficulties in a dictionary for rerolling purposes stored in the order of the type
var contractDifficulties = {Contract_Type.CAPTURE: 1, Contract_Type.DEFEND: 1, Contract_Type.ROUTE: 1}
# List of the "shiny" names
var devList = ["Haley", "Faye", "Max", "Jack", "Charlie", "Landon", "Maverick", "Mitchell", "Tyler"]:
	get:
		return devList
# List of the alien names read from a file
var alienList = ["Zavox",
				 "Xylor",
				 "Axion",
				 "Jyvona",
				 "Gorbnik",
				 "Yarli",
				 "Glixerion",
				 "Taz-rox",
				 "Torell",
				 "Fwinx",
				 "Rektha",
				 "Veebux",
				 "Nepharaan",
				 "Astremedus",
				 "Kalzara",
				 "Grego",
				 "Deonis",
				 "Olin",
				 "Incellius",
				 "Gavinki",
				 "Myla",
				 "Alara",
				 "Carmiya",
				 "Grandalf",
				 "Teckla",
				 "Doma-Doma",
				 "Miria",
				 "Jenssi",
				 "Keggle",
				 "Vookto",
				 "Ramesh",
				 "Zorba Zaxo Popo",
				 "Gejalli",
				 "Borvo",
				 "Grugga",
				 "Veggie",
				 "On-gob",
				 "Nokhap",
				 "Bitt",
				 "Lolgoss",
				 "Nurloss",
				 "Zhuri",
				 "Chiporr",
				 "Zhachsbiys",
				 "Siri",
				 "The Zharponator",
				 "Dog",
				 "Bifo",
				 "Polaar-Bher",
				 "Iship",
				 "Ubass",
				 "Poggin",
				 "Krasimir",
				 "Eggo",
				 "Nerdee Glump",
				 "Milyena",
				 "Duma",
				 "Aleksandra",
				 "Filpp",
				 "Bustin",
				 "Silento",
				 "Dababy",
				 "Micheal",
				 "Rhys",
				 "Layla",
				 "Rarkaz Zuss",
				 "Gorpang",
				 "Stohk",
				 "Bleemi",
				 "Grimbly",
				 "Glorpo",
				 "Prisket",
				 "Jimmo",
				 "Jimmy",
				 "Villy Vonka",
				 "Worm",
				 "Purple",
				 "Doinky",
				 "Bumblre",
				 "Beembo",
				 "Snowbaal",
				 "Myttens",
				 "Pryncess",
				 "Gru",
				 "Smumty",
				 "Gamurr",
				 "Gamyr",
				 "Gamer",
				 "Gaymer",
				 "J'traduss",
				 "Jimbothy",
				 "Soskung",
				 "Markiplier",
				 "Erorrd",
				 "Ch'anol",
				 "Gyattbuuti",
				 "Krowa",
				 "Oding",
				 "Lonzon",
				 "Glub-Sh'to",
				 "Stolgov",
				 "Banag",
				 "Kram",
				 "K'avuko",
				 "Greggrissi",
				 "Greggrissimo",
				 "Uggiz",
				 "Wango",
				 "Sigma Ba'als",
				 "Styrwyr",
				 "Vaggrock",
				 "Brenron",
				 "Fabu",
				 "Glude",
				 "Goku",
				 "Ayche",
				 "Boibi",
				 "Dwemlum",
				 "Gog",
				 "Thefir",
				 "Gamwich",
				 "Forsythia",
				 "Guh",
				 "Gorls",
				 "Rowan",
				 "Dicentra",
				 "Celeste",
				 "Filbo",
				 "Burger",
				 "Dietznuutz",
				 "Garl",
				 "Wheezer",
				 "Caaaaaaaaaarl",
				 "Vigo",
				 "Brnurt",
				 "Uuuop",
				 "Jeef",
				 "Sbiff",
				 "Garabulon Sr.",
				 "Elius",
				 "Bobi-van",
				 "Grart Unchained",
				 "Glippy",
				 "Myrcell",
				 "God's favorite fella",
				 "Eckspo Markurr",
				 "Urlf",
				 "Quazimoto",
				 "Leslie",
				 "Zimmrodd",
				 "Schlarr",
				 "Golroth",
				 "Zibzub",
				 "Grark",
				 "Golith",
				 "Schrimm",
				 "Gubgub",
				 "Gorr",
				 "Kluss",
				 "Fahltour",
				 "Scruffle",
				 "Empusmo",
				 "Grammzdahk",
				 "Oggeldy-Boggeldy-Baz",
				 "Donn'Macchio",
				 "Vysak",
				 "Eldumire",
				 "Speespee",
				 "Abdirak",
				 "Uldhere",
				 "While(0 == 0) {",
				 "Dirk Bunsby",
				 "Smamtillious",
				 "Binbaxxurr",
				 "Koala",
				 "Squala",
				 "Dimble",
				 "Thuhpollise",
				 "benny",
				 "Martrow",
				 "Phemus",
				 "Yeeddo",
				 "Asliet",
				 "Ingran",
				 "Rastol",
				 "Krame",
				 "Bophrax",
				 "Sticuks",
				 "Connun",
				 "Kren",
				 "Emae",
				 "Bilburries",
				 "Evie",
				 "Thols",
				 "Hoser",
				 "Tiequ",
				 "Zuli",
				 "Usla",
				 "Orae",
				 "Bees \"Zumpty\" Harold",
				 "Hacha",
				 "Drotons",
				 "Krinta",
				 "Yosir",
				 "Mr. Monopoly",
				 "Grenqrail",
				 "Phulli",
				 "Phaihmon",
				 "Algoith",
				 "Emphoth",
				 "Alear",
				 "Igron",
				 "Coneal",
				 "Aphrai",
				 "Sheekath",
				 "Mescoign",
				 "Uuzo",
				 "Rahmi",
				 "Thane",
				 "Zilu",
				 "Olzuk",
				 "Roca",
				 "Bheid",
				 "Ned",
				 "Biden",
				 "Amphull",
				 "Bulkien",
				 "Iegors",
				 "Trukna",
				 "Tikrak",
				 "Ossul",
				 "Brogzak",
				 "Daphon",
				 "Hongurr",
				 "Eeyee",
				 "Pomphkin",
				 "Xerqoits",
				 "Verkal",
				 "Tumbly Gumber",
				 "Jax",
				 "Xyplurferume",
				 "Qixxz",
				 "Prubbupty",
				 "Pete Brainklo",
				 "Chapp",
				 "Frebubs",
				 "Eepums",
				 "Darlax",
				 "Lorfinn",
				 "Doundee Stayrs",
				 "Ranblo",
				 "Phigmi",
				 "Stots",
				 "Shwrek",
				 "Cud Spudster",
				 "Evans",
				 "Fruggy Duggs",
				 "Pimphena",
				 "Pimphineas",
				 "Novkai",
				 "Beiga",
				 "Itoi",
				 "Zed",
				 "Duncan Tennessee",
				 "Brigna",
				 "Kostas",
				 "Greith",
				 "Batta",
				 "Zugu",
				 "Migal",
				 "Karjiga",
				 "Marty",
				 "Bug",
				 "Goznye",
				 "Mustafa",
				 "Validar",
				 "Iiago",
				 "Garon",
				 "Hans",
				 "Rubik",
				 "Sibby",
				 "Vivi",
				 "Gogo",
				 "Blibby",
				 "Schierke",
				 "Guts",
				 "Casca",
				 "Schnoxlor",
				 "Bimblor",
				 "Chonibi",
				 "Maxededo",
				 "Olatiny",
				 "Raktha Lekk",
				 "BlazeJMG-917",
				 "Chooopy",
				 "CT-5555",
				 "LD-55",
				 "HK-47",
				 "Largo",
				 "Bigubs",
				 "Shmi",
				 "Ido-wanna",
				 "Tybillus",
				 "Karsus",
				 "Agniritha",
				 "Olga",
				 "Gol",
				 "Drodger",
				 "Afifiyug",
				 "Pheet",
				 "Cygis"]:
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
		

# Called when the node enters the scene tree for the first time.
func _ready():
	#var file = FileAccess.open("res://assets/AlienNames.txt", FileAccess.READ)
	#while !file.eof_reached():
		#alienList.append(file.get_line())
	#file.close()
	#alienList.remove_at(alienList.size() - 1)
	pass

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
