extends Node2D

@onready var warning_sprite = $warning
@onready var skull = $Area2D/AnimatedSprite2D

var move_speed = 1600.0
var move_direction = Vector2.RIGHT
var moving = false

func _ready():
	warning_sprite.play()
	skull.visible = false
	start_attack()

func start_attack() -> void:
	await get_tree().create_timer(2.0).timeout
	warning_sprite.visible = false
	skull.visible = true
	moving = true

func _process(delta):
	if moving:
		skull.position += move_direction * move_speed * delta
		if skull.global_position.x < -300 or skull.global_position.x > 1500:
			queue_free()

func set_direction(direction: Vector2) -> void:
	move_direction = direction
