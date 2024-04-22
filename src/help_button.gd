extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.hide()
	$TextureRect/Name.text = GameManager.help_menu_title
	$TextureRect/Description.text = GameManager.help_menu_description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$TextureRect.hide()


func _on_help_pressed():
	$TextureRect/Name.text = GameManager.help_menu_title
	$TextureRect/Description.text = GameManager.help_menu_description
	$TextureRect.show()
