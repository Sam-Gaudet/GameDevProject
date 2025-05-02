extends Area2D

@export var damage: int = 1
var direction: String = "row" # or "column"
var index: int = 0
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64

func _ready():
	# Set up collision shape based on direction
	if direction == "row":
		$CollisionShape2D.shape.size = Vector2(GRID_SIZE * TILE_SIZE, TILE_SIZE)
		position = Vector2(0, (index - GRID_SIZE/2) * TILE_SIZE)
	else:
		$CollisionShape2D.shape.size = Vector2(TILE_SIZE, GRID_SIZE * TILE_SIZE)
		position = Vector2((index - GRID_SIZE/2) * TILE_SIZE, 0)
	
	# Play warning sequence
	await _play_warning()
	attack()

func _play_warning():
	# Blink red twice
	for i in 2:
		$Sprite2D.modulate = Color.RED
		$Sprite2D.modulate.a = 0.5
		await get_tree().create_timer(0.3).timeout
		$Sprite2D.modulate = Color.TRANSPARENT
		await get_tree().create_timer(0.3).timeout
	
	# Final flash
	$Sprite2D.modulate = Color.RED
	$Sprite2D.modulate.a = 1.0
	await get_tree().create_timer(0.2).timeout

func attack():
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(0.5).timeout # Damage window
	queue_free()
