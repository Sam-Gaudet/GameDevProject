extends Node2D

@onready var explosion = $AnimatedSprite2D
@onready var tile_sprite = $Sprite2D
@onready var area = $Area2D
@onready var collision = $AnimatedSprite2D/Area2D/CollisionShape2D

var explosion_delay = 0.1
var blink_interval = 0.1

func _ready():
	explosion.visible = false
	collision.disabled = true
	tile_sprite.modulate = Color.RED
	await start_warning()
	start_explosion()

func start_warning() -> void:
	for i in range(2):
		tile_sprite.modulate = Color.DARK_VIOLET
		await get_tree().create_timer(blink_interval).timeout
		tile_sprite.modulate = Color.WHITE
		await get_tree().create_timer(blink_interval).timeout
		tile_sprite.modulate = Color.DARK_VIOLET
		await get_tree().create_timer(blink_interval).timeout
		tile_sprite.modulate = Color.WHITE
		await get_tree().create_timer(blink_interval).timeout


func start_explosion():
	await get_tree().create_timer(explosion_delay).timeout
	explosion.visible = true
	tile_sprite.visible = false
	collision.disabled = false  # Enable collision now
	
	explosion.play("explode")
	await explosion.animation_finished
	
	queue_free()
