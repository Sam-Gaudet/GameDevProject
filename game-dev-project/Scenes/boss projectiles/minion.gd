extends Area2D

var direction = Vector2.ZERO
@export var speed: float = 200.0
var min_x = 0
var max_x = 1153
var min_y = 0
var max_y = 585

func set_direction(dir: Vector2):
	direction = dir.normalized()

func _process(delta):
	position += direction * speed * delta

	# Bounce on custom edges
	if position.x < min_x or position.x > max_x:
		direction.x *= -1
		position.x = clamp(position.x, min_x, max_x)  # Prevent sticking

	if position.y < min_y or position.y > max_y:
		direction.y *= -1
		position.y = clamp(position.y, min_y, max_y)
