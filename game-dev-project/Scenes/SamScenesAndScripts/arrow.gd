extends Area2D

@export var damage: int = 1
var direction: Vector2 = Vector2.RIGHT
var speed: float = 500.0
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64

func _ready():
	# Set initial rotation based on direction
	rotation = direction.angle()
	
	# Set up collision shape (thin rectangle in movement direction)
	if direction.x != 0: # Horizontal movement
		$CollisionShape2D.shape.size = Vector2(TILE_SIZE * 0.3, TILE_SIZE * GRID_SIZE)
	else: # Vertical movement
		$CollisionShape2D.shape.size = Vector2(TILE_SIZE * GRID_SIZE, TILE_SIZE * 0.3)
	
	# Play warning sequence
	await _play_warning()
	attack()

func _play_warning():
	# Use same warning system as sword
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
	
	# Movement tween (keeps arrow's traveling behavior)
	var target_pos = position + direction * GRID_SIZE * TILE_SIZE
	var travel_time = GRID_SIZE * TILE_SIZE / speed
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, travel_time)
	tween.tween_callback(queue_free)
	
	# Damage window (same as sword)
	await get_tree().create_timer(0.5).timeout
