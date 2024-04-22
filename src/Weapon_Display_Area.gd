class_name Weapon_Display_Area
extends TextureRect


@export var weapon: Weapon

func clear_weapon(image: Texture):
	texture = image
	weapon = null

func set_weapon(new_weapon: Weapon):
	weapon = new_weapon
	texture = weapon.image

func _on_mouse_entered():
	if(weapon != null):
		MouseDrag.display_weapon_tooltip(weapon)

func _on_mouse_exited():
	if(weapon != null):
		MouseDrag.hide_weapon_tooltip(weapon)
