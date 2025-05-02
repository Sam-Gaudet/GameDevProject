extends Area2D

@export var damage: int = 1
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64

func _ready():
	# Set up 3x3 collision rectangle
	var collision_shape = $CollisionShape2D
	collision_shape.shape.size = Vector2(3 * TILE_SIZE, 3 * TILE_SIZE)
	
	# Center the collision shape
	collision_shape.position = Vector2(1.5 * TILE_SIZE, 1.5 * TILE_SIZE)
	
	await _play_warning()
	attack()

func _play_warning():
	# Center warning flash
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
	#$AnimationPlayer.play("explode")
	#await $AnimationPlayer.animation_finished
	queue_free()
