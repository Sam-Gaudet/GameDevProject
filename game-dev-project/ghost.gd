extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var summon_up = $summon_up
@onready var summon_down = $summon_down
@onready var summon_left = $summon_left

@export var speed: float = 100.0
@export var wave_amplitude: float = 30.0
@export var wave_frequency: float = 2.0
@export var roam_bounds: Vector2 = Vector2(100, 1000)  # X range

var direction = Vector2.LEFT
var time := 0.0

func _ready():
	# Ghost enters from the right
	position = Vector2(1200, 300)
	anim.flip_h = true

	# Hide summons initially
	summon_up.visible = false
	summon_down.visible = false
	summon_left.visible = false

	# Wait 2 seconds then play summon animation
	await get_tree().create_timer(2.0).timeout
	anim.play("summon")
	await anim.animation_finished
	spawn_summons()
	anim.play("idle")

func _process(delta):
	time += delta

	# Wavy vertical movement
	var y_offset = sin(time * wave_frequency) * wave_amplitude
	position += direction * speed * delta
	position.y = 300 + y_offset

	# Flip direction at roam bounds
	if position.x < roam_bounds.x:
		direction = Vector2.RIGHT
		anim.flip_h = false
	elif position.x > roam_bounds.y:
		direction = Vector2.LEFT
		anim.flip_h = true

func spawn_summons():
	var spawn_pos = global_position

	summon_up.global_position = spawn_pos
	summon_down.global_position = spawn_pos
	summon_left.global_position = spawn_pos

	summon_up.start()
	summon_down.start()
	summon_left.start()
