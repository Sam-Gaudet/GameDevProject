extends Area2D

func _ready() -> void:
	if position.x > 1300:  # offscreen cleanup
		queue_free()
