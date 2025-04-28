extends Area2D
@export var speed: float = 100.0
@export var direction: Vector2 = Vector2.RIGHT
@export var amplitude: float = 20.0 # how high the skull waves up and down
@export var frequency: float = 2.0  # how fast it waves up and down

var start_position: Vector2
var wave_time: float = 0.0

func _ready():
	start_position = global_position
	
func _process(delta):
	wave_time += delta
	var offset_y = sin(wave_time * frequency) * amplitude
	global_position += direction * speed * delta
	global_position.y = start_position.y + offset_y

	if (global_position.x < -100 or global_position.x > 1300):
		queue_free()
