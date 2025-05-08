extends Area2D
@export var base_speed: float = 200.0
@export var direction: Vector2 = Vector2.RIGHT
@export var amplitude: float = 20.0
@export var frequency: float = 2.0

var start_position: Vector2
var wave_time: float = 0.0
var total_time: float = 0.0

func _ready():
	start_position = global_position

func _process(delta):
	wave_time += delta
	total_time += delta

	var duration = 2.0 # total time for the full curve
	var t = clamp(total_time / duration, 0, 1)

	# Custom speed curve:
	var speed_multiplier: float
	if t < 0.4:
		# Slow down rapidly from 1.0 to 0.2
		speed_multiplier = lerp(1.0, 0.2, t / 0.4)
	elif t < 0.8:
		# Stay slow
		speed_multiplier = 0.2
	else:
		# Accelerate rapidly from 0.2 to 3.0
		speed_multiplier = lerp(0.2, 3.0, (t - 0.8) / 0.2)

	var current_speed = base_speed * speed_multiplier
	var offset_y = sin(wave_time * frequency) * amplitude

	global_position += direction * current_speed * delta
	global_position.y = start_position.y + offset_y

	if global_position.x < -100 or global_position.x > 1300:
		queue_free()
