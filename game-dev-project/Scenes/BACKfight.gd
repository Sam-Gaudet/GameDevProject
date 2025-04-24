extends CanvasLayer
@export var back_speed := -50.0
@export var stars_speed := -80.0

func _process(delta):
	$back.position.x += back_speed * delta
	$back2.position.x += back_speed * delta
	$stars.position.x += stars_speed * delta
	$stars2.position.x += stars_speed * delta
