extends Node2D

@onready var temp_boss_sprite = $CanvasLayer/BossAnimatedSprite2D

func _ready():
	# Hide the sprite initially
	temp_boss_sprite.visible = false

	# Set a timer to show the sprite after 4.5 seconds
	await get_tree().create_timer(5).timeout
	temp_boss_sprite.visible = true
