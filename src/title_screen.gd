extends Node2D

@onready var play_button = $PLayButton

# Called when the node enters the scene tree for the first time.
func _ready():
	$PLayButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_p_lay_button_pressed():
	GameManager.currentContract = GameManager.ContractData.new()
	GameManager.currentContract.initialize_by_field(GameManager.Contract_Type.ROUTE, 1, 100, 0)
	GameManager.enter_combat_title(GameManager.reserve_list)
