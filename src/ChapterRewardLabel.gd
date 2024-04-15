extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if (GameManager.currentContract):
		text = "Your Reward: " + str(GameManager.currentContract.reward)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
