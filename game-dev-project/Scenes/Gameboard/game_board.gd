extends Node2D

const GRID_SIZE = 7
const TILE_SIZE = 64

const InnerTile = preload("res://Scenes/Gameboard/innerTile.tscn")
const BorderTile = preload("res://Scenes/Gameboard/border_tiles.tscn")

var timer : Timer

func _ready() -> void:
	# Create and add the Timer node to the scene
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	
	# Start generating the gameboard
	await generate_border_spiral()
	await delay(1.0)
	await generate_inner_tiles()

# Delay function for controlling tile generation pace
func delay(seconds: float) -> void:
	timer.wait_time = seconds
	timer.start()
	await timer.timeout

# Helper function to calculate the offset for positioning tiles
func get_offset() -> Vector2:
	return Vector2(GRID_SIZE / 2, GRID_SIZE / 2) * TILE_SIZE

# Function to generate the inner tiles
func generate_inner_tiles() -> void:
	var offset = get_offset()
	for y in range(1, GRID_SIZE - 1):
		for x in range(1, GRID_SIZE - 1):
			var tile = InnerTile.instantiate()
			tile.position = Vector2(x, y) * TILE_SIZE - offset
			add_child(tile)
			await delay(0.01)

# Function to generate the border spiral
func generate_border_spiral() -> void:
	var visited := []
	for _i in range(GRID_SIZE):
		visited.append([])
		for _j in range(GRID_SIZE):
			visited[_i].append(false)

	var directions = [
		Vector2i(0, 1),   # down
		Vector2i(1, 0),   # right
		Vector2i(0, -1),  # up
		Vector2i(-1, 0)   # left
		]

	var current_dir = 0
	var x = 0
	var y = 0
	var offset = get_offset()

	# Loop to create the border spiral
	for i in range(GRID_SIZE * 4 - 4):
		if x == 0 or y == 0 or x == GRID_SIZE - 1 or y == GRID_SIZE - 1:
			if not visited[y][x]:
				var tile = BorderTile.instantiate()
				tile.position = Vector2(x, y) * TILE_SIZE - offset
				add_child(tile)
				visited[y][x] = true
				await delay(0.05)

		var next_x = x + directions[current_dir].x
		var next_y = y + directions[current_dir].y

		var in_bounds = (
			next_x >= 0 and next_x < GRID_SIZE and
			next_y >= 0 and next_y < GRID_SIZE
			)

		if in_bounds and not visited[next_y][next_x] and (
			next_x == 0 or next_y == 0 or next_x == GRID_SIZE - 1 or next_y == GRID_SIZE - 1
		):
			x = next_x
			y = next_y
		else:
			current_dir = (current_dir + 1) % 4
			x += directions[current_dir].x
			y += directions[current_dir].y
