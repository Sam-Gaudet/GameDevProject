extends Node2D

# Transition variables
@onready var transition_rect = $Transition/TransitionRect
@onready var heart_sprite = $Transition/HeartSprite
@onready var camera = $PlayerPlatformer/Camera2D
@onready var animated_sprite = $PlayerPlatformer/AnimatedSprite2D
var player_position : Vector2

# Existing variables
var player_in_hub : bool = false
var player_in_boss_1 : bool = false
var player_in_boss_2 : bool = false
var player_in_boss_3 : bool = false

@onready var hub_dialogue = %Dialogue
@onready var boss_dialogue = %DialogueBoss
@onready var pause_menu = $PauseMenu/PauseMenu/PauseMenu

var is_transitioning_to_boss: bool = false

func _ready():
	# Initialize transition elements as hidden
	transition_rect.visible = false
	heart_sprite.visible = false
	
	hub_dialogue.hide_dialogue()
	boss_dialogue.hide_dialogue()
	
	pause_menu.visible = true
	
	# Set up pause menu content
	var menu_content = {
		"instructions": "Find boss 1",
		"story": "Current story progress...",
		"task": "Current objectives:",
		"controls": "Movement: WASD\nJump: Space"
	}
	
	pause_menu.set_content(menu_content)
	pause_menu.close_menu()  # Start close

# Hub -------------------------------------------
func _on_hub_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_hub = true
		hub_dialogue.show_text("Travel to hub")

func _on_hub_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_hub = false
		hub_dialogue.hide_dialogue()
		

# Boss 1 -------------------------------------------
func _on_boss_1_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_1 = true
		boss_dialogue.show_text("Fight boss 1")

func _on_boss_1_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_1 = false
		boss_dialogue.hide_dialogue()

# Boss 2 -------------------------------------------
func _on_boss_2_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_2 = true
		boss_dialogue.show_text("Fight boss 2")

func _on_boss_2_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_2 = false
		boss_dialogue.hide_dialogue()
		
# Boss 3 -------------------------------------------
func _on_boss_3_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_3 = true
		boss_dialogue.show_text("Fight boss 3")

func _on_boss_3_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_boss_3 = false
		boss_dialogue.hide_dialogue()

func _input(event: InputEvent) -> void:
	if player_in_hub and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/hub.tscn")
		
	if (player_in_boss_1 or player_in_boss_2 or player_in_boss_3) and event.is_action_pressed("ui_accept") and not is_transitioning_to_boss:
		start_boss_transition()

func start_boss_transition():
	is_transitioning_to_boss = true
	var player = get_node("PlayerPlatformer")
	if player.has_method("set_movement_enabled"):
		player.set_movement_enabled(false)  
		animated_sprite.play("idle")
	player_position = player.global_position
	
	# Position heart at player location (hidden initially)
	var camera_offset = Vector2(0, 0)
	var target_position = player_position + camera_offset
	heart_sprite.position = target_position
	
	# Start by moving camera to center on player (with its offset)
	var move_tween = create_tween()
	move_tween.tween_property(camera, "global_position", target_position, 1).set_ease(Tween.EASE_OUT)
	move_tween.parallel().tween_property(camera, "zoom", Vector2(1.7, 1.7), 1).set_ease(Tween.EASE_OUT)
	
	move_tween.tween_callback(start_flash_sequence)

func start_flash_sequence():
	# Fade to black
	transition_rect.visible = true
	heart_sprite.visible = true
	
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

func show_boss_warning():
	# Set special boss warning content
	var boss_warning_content = {
		"instructions": "BOSS WARNING",
		"story": "Prepare for battle!",
		"task": "This will be a tough fight.",
		"controls": "Good luck!"
	}
	
	pause_menu.set_content(boss_warning_content)
	pause_menu.show_only_book_and_notes()
	pause_menu.open_menu()
	
	# Wait for menu to close before proceeding
	pause_menu.connect("menu_closed", Callable(self, "_on_boss_warning_closed"), CONNECT_ONE_SHOT)

func _on_boss_warning_closed():
	pause_menu.hide_all_for_transition()
	change_to_boss_scene()

func final_zoom_and_fade():
	# Zoom in further while fading out heart
	var final_tween = create_tween()
	final_tween.tween_property(camera, "zoom", Vector2(100, 100), 1).set_ease(Tween.EASE_IN)
	final_tween.parallel().tween_property(heart_sprite, "modulate:a", 0, 0.8)
	final_tween.tween_callback(show_boss_warning)

func change_to_boss_scene():
	if player_in_boss_1:
		get_tree().change_scene_to_file("res://Scenes/AlexisScenesAndScripts/boss_fight_1.tscn")
	elif player_in_boss_2:
		get_tree().change_scene_to_file("res://Scenes/SamScenesAndScripts/boss_fight_2.tscn")
	elif player_in_boss_3:
		get_tree().change_scene_to_file("res://Scenes/final_fight.tscn")
	is_transitioning_to_boss = false
