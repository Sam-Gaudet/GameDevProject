extends Area2D
@onready var animation_player = $AnimatedSprite2D
func _ready():
	animation_player.play("explode")

func _on_animated_sprite_2d_animation_finished() -> void:
		queue_free()
