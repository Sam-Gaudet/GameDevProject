extends Node2D

@onready var explosion = $AnimatedSprite2D
@onready var tile_sprite = $Sprite2D

var explosion_delay = 0.5
var blink_interval = 0.2

func _ready():
	explosion.visible = false
	tile_sprite.modulate = Color.RED
	await start_warning()
	start_explosion()

func start_warning() -> void:
	for i in range(2):
		tile_sprite.modulate = Color.DARK_RED
		await get_tree().create_timer(blink_interval).timeout
		tile_sprite.modulate = Color.ORANGE_RED
		await get_tree().create_timer(blink_interval).timeout
		tile_sprite.modulate = Color.DARK_RED
		await get_tree().create_timer(blink_interval).timeout
		tile_sprite.modulate = Color.ORANGE_RED

func start_explosion():
	await get_tree().create_timer(explosion_delay).timeout
	explosion.visible = true
	tile_sprite.visible = false
	explosion.play("explode")
	await explosion.animation_finished
	queue_free()
