extends Area2D

@onready var anim = $AnimatedSprite2D
@export var stop_x: float = 1100.0
@export var speed: float = 200.0
@export var wave_amplitude: float = 30.0
@export var wave_frequency: float = 2.0
var time := 0.0

var state = "entering"
var summon_callback: Callable 

func _ready():
	anim.play("idle")
	anim.flip_h = true
	position = Vector2(1200, 300)

func _process(delta):
	time += delta
	if state == "entering":
		# Move left and apply wave motion
		position.x -= speed * delta
		position.y = 300 + sin(time * wave_frequency) * wave_amplitude
		
		if position.x <= stop_x:
			position.x = stop_x
			state = "summoning"
			start_summon()

func start_summon() -> void:
	await get_tree().create_timer(2.0).timeout
	anim.play("summon")
	await anim.animation_finished
	anim.play("idle")

	if summon_callback:
		summon_callback.call()

	anim.play("death")
	await anim.animation_finished

	queue_free()
