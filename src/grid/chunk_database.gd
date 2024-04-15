extends Node2D


## The grid's rows and columns.
@export var size := Vector2(20, 20)
## The size of a cell in pixels.
@export var cell_size := Vector2(16, 16)


func _ready():
	hide()


func get_random_chunk() -> Chunk:
	var chunk = get_children().pick_random()
	while chunk.name == "PlayerChunk":
		chunk = get_children().pick_random()
	
	return chunk


func get_random_chunk_by_difficulty(difficulty: int) -> Chunk:
	var chunk = get_children().pick_random()
	
	var iterations = 0
	while (chunk.difficulty != difficulty || chunk.name == "PlayerChunk") && iterations > 20:
		chunk = get_children().pick_random()
		iterations += 1
	
	if iterations > 20:
		print("error: could not find chunk with given difficulty " + str(difficulty))
	
	return chunk

func get_random_chunk_by_contract_difficulty() -> Chunk:
	var rng = RandomNumberGenerator.new()
	match GameManager.currentContract.difficulty_stars:
		1:
			# 90/10/0 % chance of difficulty 1/2/3
			var rngValue = rng.randi_range(1, 10)
			if (rngValue <= 9):
				return get_random_chunk_by_difficulty(1)
			else:
				return get_random_chunk_by_difficulty(2)
		2:
			# 50/40/10 % chance of difficulty 1/2/3
			var rngValue = rng.randi_range(1, 10)
			if (rngValue <= 5):
				return get_random_chunk_by_difficulty(1)
			elif (rngValue <= 9):
				return get_random_chunk_by_difficulty(2)
			else:
				return get_random_chunk_by_difficulty(3)
		3:
			# 20/40/40 % chance of difficulty 1/2/3
			var rngValue = rng.randi_range(1, 10)
			if (rngValue <= 2):
				return get_random_chunk_by_difficulty(1)
			elif (rngValue <= 6):
				return get_random_chunk_by_difficulty(2)
			else:
				return get_random_chunk_by_difficulty(3)
		4:
			# 10/40/50 % chance of difficulty 1/2/3
			var rngValue = rng.randi_range(1, 10)
			if (rngValue <= 1):
				return get_random_chunk_by_difficulty(1)
			elif (rngValue <= 5):
				return get_random_chunk_by_difficulty(2)
			else:
				return get_random_chunk_by_difficulty(3)
		5:
			# 0/10/90 % chance of difficulty 1/2/3
			var rngValue = rng.randi_range(1, 10)
			if (rngValue <= 1):
				return get_random_chunk_by_difficulty(2)
			else:
				return get_random_chunk_by_difficulty(3)
	return null

func get_player_chunk() -> Chunk:
	return $PlayerChunk


## Returns the position of a cell's center in pixels.
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + cell_size / 2


## Returns the coordinates of the cell on the grid given a position on the map.
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()


## Returns true if the `cell_coordinates` are within the grid.
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y


## Makes the `grid_position` fit within the grid's bounds.
func grid_clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out
