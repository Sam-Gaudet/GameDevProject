extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == ("PlayerPlatformer"):
		$CollisionShape2D/fight.visible = true
