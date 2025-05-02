extends Area2D

var direction := Vector2.RIGHT
var speed := 100
var amplitude := 60.0
var frequency := 2.0
var time := 0.0
var start_y := 0.0

func _ready():
	start_y = global_position.y

func _process(delta: float) -> void:
	time += delta
	var wave_offset = sin(time * frequency) * amplitude
	position += direction * speed * delta
	position.y = start_y + wave_offset

	if position.x > 1300:  # offscreen cleanup
		queue_free()
