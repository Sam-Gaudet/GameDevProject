extends Node2D

@onready var warning_sprite = $warning
@onready var skull = $Area2D/AnimatedSprite2D

var move_speed = 800.0 # Speed of the skull
var move_direction = Vector2.RIGHT # Default moving right
var moving = false

func _ready():
	warning_sprite.play() # Play warning animation
	skull.visible = false # Hide skull at start

	start_attack()

func start_attack() -> void:
	await get_tree().create_timer(3.0).timeout

	warning_sprite.visible = false
	skull.visible = true

	moving = true

func _process(delta):
	if moving:
		skull.position += move_direction * move_speed * delta

		# If the skull is offscreen, free this attack scene
	if skull.global_position.x < -300 or skull.global_position.x > 1500:
		queue_free()
