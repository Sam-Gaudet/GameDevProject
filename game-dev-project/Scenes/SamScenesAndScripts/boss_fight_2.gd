extends Node2D

const STRIKE_SCENE = preload("res://Scenes/SamScenesAndScripts/sword.tscn")
const GRID_SIZE = 7
const TILE_SIZE = 64

# Predictable pattern (top row → left col → middle row → right col → bottom row)
var strike_pattern = [
	{"type": "row", "index": 0},    # Top row
	{"type": "col", "index": 0},    # Left column
	{"type": "row", "index": 3},    # Middle row
	{"type": "col", "index": 3},    # Middle column
	{"type": "row", "index": 6},    # Bottom row
	{"type": "col", "index": 6}     # Right column
]
var current_pattern_index = 0

func _ready():
	start_strike_cycle()

func start_strike_cycle():
	while true:
		var pattern = strike_pattern[current_pattern_index]
		spawn_strike(pattern["type"], pattern["index"])
		
		# Move to next pattern (looping)
		current_pattern_index = (current_pattern_index + 1) % strike_pattern.size()
		await get_tree().create_timer(3.0).timeout  # 3s between strikes

func spawn_strike(type: String, index: int):
	var strike = STRIKE_SCENE.instantiate()
	
	# Position and scale based on row/column
	if type == "row":
		strike.position = Vector2(0, (index - GRID_SIZE/2) * TILE_SIZE)
		strike.scale = Vector2(GRID_SIZE, 1)
	else:  # column
		strike.position = Vector2((index - GRID_SIZE/2) * TILE_SIZE, 0)
		strike.scale = Vector2(1, GRID_SIZE)
	
	# Connect damage signal
	strike.body_entered.connect(_on_strike_hit_player)
	add_child(strike)

func _on_strike_hit_player(body: Node):
	if body.name == "PlayerPlatformer":
		body.take_damage(1)
