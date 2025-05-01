extends Area2D

@export var speed := 200.0
var direction = Vector2.ZERO
var active := false

func start():
	visible = true
	active = true
	direction = Vector2(0, 1)

func _process(delta):
	if not active:
		return

	position += direction * speed * delta

	# Bounce inside bounds (0,0) to (1153,672)
	if position.x <= 0 or position.x >= 1153:
		direction.x *= -1
	if position.y <= 0 or position.y >= 672:
		direction.y *= -1
