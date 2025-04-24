extends ParallaxBackground
@export var scroll_speed := Vector2(50, 50)

func _process(delta):
	scroll_offset += scroll_speed * delta
