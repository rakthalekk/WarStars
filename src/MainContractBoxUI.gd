extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if (GameManager.currentContract):
		match GameManager.currentContract.type:
			GameManager.Contract_Type.CAPTURE:
				text = "Capture The Flag"
			GameManager.Contract_Type.DEFEND:
				text = "Defend The Area For " + str(GameManager.currentContract.defend_turns) + " Turns"
			GameManager.Contract_Type.ROUTE:
				text = "Route The Enemy"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
