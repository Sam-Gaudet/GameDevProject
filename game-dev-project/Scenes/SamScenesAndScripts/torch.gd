extends Node2D

@onready var animated_sprite = %Torch 

func _ready():
	animated_sprite.play("default")
