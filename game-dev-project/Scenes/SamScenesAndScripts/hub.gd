extends Node2D

var player_in_main_menu : bool = false
var player_in_door_1 : bool = false
var player_in_door_2 : bool = false
var player_in_door_3 : bool = false

# Dialogue / Pause menu
@onready var main_menu_dialogue = %Dialogue
@onready var portal1_dialogue = $Door1/CanvasLayer/Dialogue
@onready var portal2_dialogue = $Door2/CanvasLayer/Dialogue
@onready var portal3_dialogue = $Door3/CanvasLayer/Dialogue
@onready var pause_menu = $PauseMenu/PauseMenu/PauseMenu
@onready var transition_rect = $Transition/TransitionRect

func _ready():
	$Ambience.play()
	$HubMusic.play()
	pause_menu.visible = true
	main_menu_dialogue.hide_dialogue()
	portal1_dialogue.hide_dialogue()
	portal2_dialogue.hide_dialogue()
	portal3_dialogue.hide_dialogue()
	# Set up pause menu content
	
	var menu_content = {
		"story": "MainStory",
		"controls": "MainControls"
	}
	
	if LevelManager.is_level_done("level3"):
		menu_content["instructions"] = "NoBossInstructions"
		menu_content["task"] = "NoBossTask"
	elif LevelManager.is_level_done("level2"):
		menu_content["instructions"] = "Boss3Instructions"
		menu_content["task"] = "Boss3Task"
	elif LevelManager.is_level_done("level1"):
		menu_content["instructions"] = "Boss2Instructions"
		menu_content["task"] = "Boss2Task"
	else:
		menu_content["instructions"] = "Boss1Instructions"
		menu_content["task"] = "Boss1Task"
	
	pause_menu.set_content(menu_content)
	pause_menu.close_menu()  # Start close
	
	# Start with black screen
	transition_rect.color = Color(0, 0, 0, 1)
	transition_rect.visible = true
	
	var fade_tween = create_tween()
	fade_tween.tween_property(transition_rect, "color:a", 0, 1.0)
	

# Main menu -------------------------------------------
func _on_main_menu_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_main_menu = true
		main_menu_dialogue.show_text("TravelMainMenu")
	
func _on_main_menu_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_main_menu = false
		main_menu_dialogue.hide_dialogue()

# Door one -------------------------------------------
func _on_door_1_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_1 = true
		portal1_dialogue.show_text("TravelBoss1")

func _on_door_1_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_1 = false
		portal1_dialogue.hide_dialogue()
		
# Door two -------------------------------------------
func _on_door_2_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_2 = true
		if LevelManager.is_level_done("level1"):
			portal2_dialogue.show_text("TravelBoss2")
		else:
			$Door2/CanvasLayer/Dialogue/DialogueLayer/ControlsLayer.modulate.a = 0.0
			portal2_dialogue.show_text("NoTravelBoss2")

func _on_door_2_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_2 = false
		portal2_dialogue.hide_dialogue()
		
# Door three -------------------------------------------
func _on_door_3_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_3 = true
		if LevelManager.is_level_done("level2"):
			portal3_dialogue.show_text("TravelBoss3")
		else:
			$Door3/CanvasLayer/Dialogue/DialogueLayer/ControlsLayer.modulate.a = 0.0
			portal3_dialogue.show_text("NoTravelBoss3")

func _on_door_3_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_3 = false
		portal3_dialogue.hide_dialogue()

# Add this new function for reusable transitions
func transition_to_scene(scene_path: String, fade_duration: float = 1.0) -> void:
	# Disable player input during transition
	var player = $PlayerPlatformer
	if player.has_method("set_movement_enabled"):
		player.set_movement_enabled(false)
	
	# Start fade out
	transition_rect.color = Color(0, 0, 0, 0)
	transition_rect.visible = true
	
	var fade_tween = create_tween()
	fade_tween.tween_property(transition_rect, "color:a", 1, fade_duration)
	fade_tween.tween_callback(func ():
		get_tree().change_scene_to_file(scene_path)
	)

# Modified input handler
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# Main menu
		if player_in_main_menu:
			transition_to_scene("res://Scenes/AlexisScenesAndScripts/main_menu.tscn")
		
		# Door one
		elif player_in_door_1:
			transition_to_scene("res://Scenes/SamScenesAndScripts/platformer1.tscn")
		
		# Door two
		elif player_in_door_2 and LevelManager.is_level_done("level1"):
			transition_to_scene("res://Scenes/SamScenesAndScripts/platformer2.tscn")
		
		# Door three
		elif player_in_door_3 and LevelManager.is_level_done("level2"):
			transition_to_scene("res://Scenes/SamScenesAndScripts/platformer3.tscn")
