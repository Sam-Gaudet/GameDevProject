extends Node2D

const SWORD_ATTACK = preload("res://Scenes/SamScenesAndScripts/sword.tscn")
const ARROW_ATTACK = preload("res://Scenes/SamScenesAndScripts/arrow.tscn")
const BOMB_ATTACK = preload("res://Scenes/SamScenesAndScripts/bomb.tscn")
const GRID_SIZE = 7
const TILE_SIZE = 64

# Learnable pattern sequence
var attack_pattern = [
	{"type": "sword", "direction": "row", "index": 0},    # Top row
	{"type": "arrow", "direction": Vector2.RIGHT},        # Right-moving arrow
	{"type": "bomb", "position": Vector2(3, 3)},          # Center bomb
	{"type": "sword", "direction": "column", "index": 6}, # Right column
	{"type": "arrow", "direction": Vector2.DOWN},         # Down-moving arrow
]
var current_pattern_index = 0

func _ready():
	start_attack_cycle()

func start_attack_cycle():
	while true:
		var attack = attack_pattern[current_pattern_index]
		
		match attack["type"]:
			"sword":
				var sword = SWORD_ATTACK.instantiate()  # Add instantiate()
				sword.GRID_SIZE = GRID_SIZE  # Pass grid parameters
				sword.TILE_SIZE = TILE_SIZE
				sword.direction = attack["direction"]
				sword.index = attack["index"]
				add_child(sword)
			
			"arrow":
				var arrow = ARROW_ATTACK.instantiate()  # Add instantiate()
				arrow.GRID_SIZE = GRID_SIZE  # Pass grid parameters
				arrow.TILE_SIZE = TILE_SIZE
				arrow.direction = attack["direction"]
				arrow.speed = 500.0  # Set arrow speed
				
				# Position arrow just outside grid in correct direction
				if attack["direction"] == Vector2.RIGHT:
					arrow.position = Vector2(-TILE_SIZE, 3 * TILE_SIZE)
				elif attack["direction"] == Vector2.LEFT:
					arrow.position = Vector2(GRID_SIZE * TILE_SIZE, 3 * TILE_SIZE)
				elif attack["direction"] == Vector2.DOWN:
					arrow.position = Vector2(3 * TILE_SIZE, -TILE_SIZE)
				elif attack["direction"] == Vector2.UP:
					arrow.position = Vector2(3 * TILE_SIZE, GRID_SIZE * TILE_SIZE)
				add_child(arrow)
			
			"bomb":
				var bomb = BOMB_ATTACK.instantiate()  # Add instantiate()
				bomb.GRID_SIZE = GRID_SIZE  # Pass grid parameters
				bomb.TILE_SIZE = TILE_SIZE
				bomb.position = attack["position"] * TILE_SIZE - Vector2(GRID_SIZE/2, GRID_SIZE/2) * TILE_SIZE
				add_child(bomb)
		
		# Move to next pattern
		current_pattern_index = (current_pattern_index + 1) % attack_pattern.size()
		await get_tree().create_timer(3.0).timeout  # Time between attacks
