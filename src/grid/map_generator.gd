extends Node2D

const ENEMY_UNIT = preload("res://src/enemy_unit.tscn")

@export var chunk_grid_size: Vector2
@export var player_chunk_position: Vector2

@onready var tilemap = get_parent().get_node("Map")
@onready var game_board = get_parent().get_node("GameBoard")
@onready var camera = get_parent().get_node("Camera2D") as Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ChunkDatabase.size = chunk_grid_size * 8
	camera.limit_bottom = ChunkDatabase.size.y * ChunkDatabase.cell_size.x + 96
	camera.limit_right = ChunkDatabase.size.x * ChunkDatabase.cell_size.y + 96
	
	for i in range(chunk_grid_size.x):
		for j in range(chunk_grid_size.y):
			var chunk = null
			if GameManager.currentContract:
				chunk = ChunkDatabase.get_random_chunk_by_contract_difficulty()
			else:
				chunk = ChunkDatabase.get_random_chunk()
			
			if Vector2(i, j) == player_chunk_position:
				chunk = ChunkDatabase.get_player_chunk()
			
			for x in range(8):
				for y in range(8):
					var grid_position = Vector2i(i*8 + x, j*8 + y)
					var atlas = chunk.get_cell_atlas_coords(1, Vector2i(x, y))
					tilemap.set_cell(0, grid_position, 0, atlas)
					
					var enemy_spawn = chunk.get_cell_atlas_coords(0, Vector2i(x, y))
					if enemy_spawn.x == 0:
						var enemy = ENEMY_UNIT.instantiate() as EnemyUnit
						enemy.position = grid_position * 16
						game_board.add_child(enemy)
