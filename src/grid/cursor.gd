## Player-controlled cursor. Allows them to navigate the game grid, select units, and move them.
## Supports both keyboard and mouse (or touch) input.
class_name Cursor
extends Node2D

## Emitted when clicking on the currently hovered cell or when pressing "ui_accept".
signal accept_pressed(cell)
## Emitted when the cursor moved to a new cell.
signal moved(new_cell)

## Time before the cursor can move again in seconds.
@export var ui_cooldown := 0.02

var move_held = false
var controller = false

## Coordinates of the current cell the cursor is hovering.
var cell := Vector2.ZERO:
	set(value):
		# We first clamp the cell coordinates and ensure that we aren't
		#	trying to move outside the grid boundaries
		var new_cell: Vector2 = ChunkDatabase.grid_clamp(value)
		if new_cell.is_equal_approx(cell):
			return

		cell = new_cell
		# If we move to a new cell, we update the cursor's position, emit
		#	a signal, and start the cooldown timer that will limit the rate
		#	at which the cursor moves when we keep the direction key held
		#	down
		position = ChunkDatabase.calculate_map_position(cell)
		emit_signal("moved", cell)
		_timer.start()

var active = true

@onready var _timer: Timer = $Timer


func _ready() -> void:
	_timer.wait_time = ui_cooldown
	position = ChunkDatabase.calculate_map_position(cell)


func _unhandled_input(event: InputEvent) -> void:
	# Navigating cells with the mouse.
	if !controller && event is InputEventMouseMotion:
		cell = ChunkDatabase.calculate_grid_coordinates(get_global_mouse_position())
	# Trying to select something in a cell.
	elif event.is_action_pressed("click"):
		emit_signal("accept_pressed", cell)
		get_viewport().set_input_as_handled()


func _process(delta):
	if controller:
		handle_button_input()


func handle_button_input():
	if Input.is_action_just_pressed("navigate_left"):
		cell += Vector2.LEFT
		_timer.start(0.5)
		move_held = true
	elif Input.is_action_just_pressed("navigate_right"):
		cell += Vector2.RIGHT
		_timer.start(0.5)
		move_held = true
	elif Input.is_action_just_pressed("navigate_up"):
		cell += Vector2.UP
		_timer.start(0.5)
		move_held = true
	elif Input.is_action_just_pressed("navigate_down"):
		cell += Vector2.DOWN
		_timer.start(0.5)
		move_held = true
	
	if not active || !_timer.is_stopped():
		return
	
	# Alternate input handling for cursor moving
	if Input.is_action_pressed("navigate_left"):
		cell += Vector2.LEFT
		if move_held:
			_timer.start(ui_cooldown)
	elif Input.is_action_pressed("navigate_right"):
		cell += Vector2.RIGHT
		if move_held:
			_timer.start(ui_cooldown)
	elif Input.is_action_pressed("navigate_up"):
		cell += Vector2.UP
		if move_held:
			_timer.start(ui_cooldown)
	elif Input.is_action_pressed("navigate_down"):
		cell += Vector2.DOWN
		if move_held:
			_timer.start(ui_cooldown)
	else:
		move_held = false

