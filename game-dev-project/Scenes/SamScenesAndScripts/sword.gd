extends Area2D

@export var fade_time: float = 2.0
@export var damage: int = 1
var can_damage: bool = false

func _ready():
	# Initial setup
	$CollisionShape2D.disabled = true
	$Sprite2D.modulate.a = 0.5
	
	# Fade-in animation
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 1.0, fade_time)
	tween.tween_callback(enable_damage)
	tween.tween_interval(0.5)  # Damage window
	tween.tween_callback(queue_free)

func enable_damage():
	$CollisionShape2D.disabled = false
	can_damage = true
