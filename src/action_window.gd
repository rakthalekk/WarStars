extends Control

@onready var game_board = get_parent().get_node("GameBoard") as GameBoard

@onready var action_button = $Buttons/Action as TextureButton
@onready var wait_button = $Buttons/Wait as TextureButton
@onready var cancel_button = $Buttons/Cancel as TextureButton

@onready var button_click = get_parent().get_node("ButtonClick") as AudioStreamPlayer

func display():
	show()
	$MenuCursor.hide()
	$Submenu.hide()
	action_button.grab_focus()


func update_buttons():
	if $Buttons/Action.visible:
		wait_button.position = Vector2(0, 10)
		cancel_button.position = Vector2(0, 20)
	else:
		wait_button.position = Vector2(0, 0)
		cancel_button.position = Vector2(0, 10)


func _on_action_pressed():
	$Submenu.show()
	$Submenu/Weapon1/Weapon1Button.grab_focus()
	button_click.play()


func _on_wait_pressed():
	game_board.end_action()
	$Submenu.hide()
	button_click.play()


func _on_cancel_pressed():
	game_board.cancel_action()
	$Submenu.hide()
	button_click.play()


func _on_action_mouse_entered():
	$MenuCursor.show()
	$MenuCursor.position = Vector2(-2, 12)
	action_button.position += Vector2(-2, 0)


func _on_wait_mouse_entered():
	$MenuCursor.show()
	if $Buttons/Action.visible:
		$MenuCursor.position = Vector2(-2, 22)
	else:
		$MenuCursor.position = Vector2(-2, 12)
	wait_button.position += Vector2(-2, 0)


func _on_cancel_mouse_entered():
	$MenuCursor.show()
	if $Buttons/Action.visible:
		$MenuCursor.position = Vector2(-2, 32)
	else:
		$MenuCursor.position = Vector2(-2, 22)
	cancel_button.position += Vector2(-2, 0)


func _on_action_mouse_exited():
	action_button.position += Vector2(2, 0)


func _on_wait_mouse_exited():
	wait_button.position += Vector2(2, 0)


func _on_cancel_mouse_exited():
	cancel_button.position += Vector2(2, 0)


func _on_weapon_1_button_pressed():
	game_board._active_unit.switch_weapons(0)
	game_board.attacking = true
	game_board.highlight_targets(true)
	hide()
	$Submenu.hide()
	button_click.play()


func _on_weapon_2_button_pressed():
	game_board._active_unit.switch_weapons(1)
	game_board.attacking = true
	game_board.highlight_targets(true)
	hide()
	$Submenu.hide()
	button_click.play()


func _on_ability_1_button_pressed():
	var unit = game_board._active_unit
	if unit.weapons.size() >= 3:
		unit.switch_weapons(2)
		if unit.weapons[2].can_use_active():
			game_board.self_targeting = true
			_use_gear(unit)
			hide()
			$Submenu.hide()
			button_click.play()


func _on_ability_2_button_pressed():
	var unit = game_board._active_unit
	if unit.weapons.size() >= 4:
		unit.switch_weapons(3)
		if unit.weapons[3].can_use_active():
			game_board.self_targeting = true
			_use_gear(unit)
			hide()
			$Submenu.hide()
			button_click.play()

func _use_gear(unit):
	match(unit.active_weapon.use_type):
		(Gear.USE_TYPE.ENEMY):
			game_board.attacking = true
			game_board.highlight_targets(true)
		(Gear.USE_TYPE.SELF):
			game_board.self_targeting = true
			game_board.highlight_self(true)
		(Gear.USE_TYPE.TERRAIN):
			# TODO make some kind of confirm popup and do the effect
			pass

func _on_weapon_1_button_mouse_entered():
	$Submenu/SubmenuCursor.position = $Submenu/Weapon1.position + Vector2(1, 6)
	$Submenu/Weapon1/Weapon1Button.position += Vector2(-2, 0)
	game_board._active_unit.switch_weapons(0)
	game_board.draw_attack_range()


func _on_weapon_2_button_mouse_entered():
	$Submenu/SubmenuCursor.position = $Submenu/Weapon2.position + Vector2(1, 6)
	$Submenu/Weapon2/Weapon2Button.position += Vector2(-2, 0)
	if game_board._active_unit.weapons.size() > 1:
		game_board._active_unit.switch_weapons(1)
	game_board.draw_attack_range()


func _on_ability_1_button_mouse_entered():
	$Submenu/SubmenuCursor.position = $Submenu/Ability1.position + Vector2(1, 6)
	$Submenu/Ability1/Ability1Button.position += Vector2(-2, 0)


func _on_ability_2_button_mouse_entered():
	$Submenu/SubmenuCursor.position = $Submenu/Ability2.position + Vector2(1, 6)
	$Submenu/Ability2/Ability2Button.position += Vector2(-2, 0)


func _on_action_cancel_pressed():
	$Submenu.hide()
	game_board._unit_attack_range.clear()
	action_button.grab_focus()
	button_click.play()


func _on_action_cancel_mouse_entered():
	$Submenu/SubmenuCursor.position = $Submenu/Cancel.position + Vector2(1, 6)
	$Submenu/Cancel/ActionCancel.position += Vector2(-2, 0)


func _on_action_cancel_mouse_exited():
	$Submenu/Cancel/ActionCancel.position += Vector2(2, 0)


func _on_weapon_1_button_mouse_exited():
	$Submenu/Weapon1/Weapon1Button.position += Vector2(2, 0)


func _on_weapon_2_button_mouse_exited():
	$Submenu/Weapon2/Weapon2Button.position += Vector2(2, 0)


func _on_ability_1_button_mouse_exited():
	$Submenu/Ability1/Ability1Button.position += Vector2(2, 0)


func _on_ability_2_button_mouse_exited():
	$Submenu/Ability2/Ability2Button.position += Vector2(2, 0)
