extends RigidBody2D

@export var speed := 150.0
@export var direction := Vector2.RIGHT  # Default to moving right

func _ready():
	direction = direction.normalized()
	linear_velocity = direction * speed

func _physics_process(delta):
	# Optional: Check if the summon has gone out of bounds, reset direction, or other logic
	var pos = global_position

	if pos.x <= 0 or pos.x >= 1200:
		direction.x *= -1
		linear_velocity = direction * speed

	if pos.y <= 0 or pos.y >= 600:
		direction.y *= -1
		linear_velocity = direction * speed
