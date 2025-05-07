extends Node2D

# Remind for later!!!!!!!!! Scrap most of this code. Just zoom onto player before black screen, flash heart 3 tines, then zoom in again with heart fading out
# Transition variables
@onready var transition_rect = $Transition/TransitionRect
@onready var heart_sprite = $Transition/HeartSprite
@onready var camera = $PlayerPlatformer/Camera2D
var player_position : Vector2

# Existing variables
var player_in_hub : bool = false
var player_in_boss_1 : bool = false
var player_in_boss_2 : bool = false
var player_in_boss_3 : bool = false

func _ready():
	# Initialize transition elements as hidden
	transition_rect.visible = false
	heart_sprite.visible = false
	transition_rect.color = Color(0, 0, 0, 0)  # Start transparent
	

# Hub -------------------------------------------
func _on_hub_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_hub = true

func _on_hub_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_hub = false
		

# Boss 1 -------------------------------------------
func _on_boss_1_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_1 = true


func _on_boss_1_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_1 = false

# Boss 2 -------------------------------------------
func _on_boss_2_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_2 = true


func _on_boss_2_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_2 = false
		
# Boss 3 -------------------------------------------
func _on_boss_3_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_3 = true


func _on_boss_3_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_3 = false


func _input(event: InputEvent) -> void:
	if player_in_hub and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/hub.tscn")
		
	if (player_in_boss_1 or player_in_boss_2 or player_in_boss_3) and event.is_action_pressed("ui_accept"):
		start_boss_transition()
		

func start_boss_transition():
	var player = get_node("PlayerPlatformer")
	player_position = player.global_position
	player.visible = false

	# Position heart at player location (hidden initially)
	heart_sprite.global_position = player_position
	heart_sprite.scale = Vector2(1, 1)
	heart_sprite.modulate = Color(1, 1, 1, 1)
	heart_sprite.visible = false

	# Start by zooming camera onto player
	var zoom_tween = create_tween()
	zoom_tween.tween_property(camera, "zoom", Vector2(1.2, 1.2), 1).set_ease(Tween.EASE_OUT)
	zoom_tween.tween_callback(start_flash_sequence)

func start_flash_sequence():
	# Fade to black
	transition_rect.visible = true
	var fade_tween = create_tween()
	fade_tween.tween_property(transition_rect, "color", Color(0, 0, 0, 1), 0.3)
	fade_tween.tween_callback(flash_heart)

func flash_heart():
	# Show heart at zoomed player position
	heart_sprite.visible = true

	# Flash heart 3 times
	var flash_tween = create_tween()
	for i in 3:
		flash_tween.tween_property(heart_sprite, "modulate:a", 0.3, 0.15)
		flash_tween.tween_property(heart_sprite, "modulate:a", 1.0, 0.15)
		flash_tween.tween_interval(0.1)

	flash_tween.tween_callback(final_zoom_and_fade)

func final_zoom_and_fade():
	# Zoom in further while fading out heart
	var final_tween = create_tween()

	# Zoom camera more (adjust these values to your liking)
	final_tween.tween_property(camera, "zoom", Vector2(0.2, 0.2), 0.8).set_ease(Tween.EASE_IN)

	# Simultaneously fade out heart
	final_tween.parallel().tween_property(heart_sprite, "modulate:a", 0, 0.8)

	# Change scene when complete
	final_tween.tween_callback(change_to_boss_scene)

func change_to_boss_scene():
	if player_in_boss_1:
		get_tree().change_scene_to_file("res://Scenes/AlexisScenesAndScripts/boss_fight_1.tscn")
	elif player_in_boss_2:
		get_tree().change_scene_to_file("res://Scenes/SamScenesAndScripts/boss_fight_2.tscn")
	elif player_in_boss_3:
		get_tree().change_scene_to_file("res://Scenes/final_fight.tscn")
