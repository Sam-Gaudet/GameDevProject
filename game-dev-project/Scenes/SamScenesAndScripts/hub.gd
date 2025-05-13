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

func _ready():
	pause_menu.visible = true
	main_menu_dialogue.hide_dialogue()
	portal1_dialogue.hide_dialogue()
	portal2_dialogue.hide_dialogue()
	portal3_dialogue.hide_dialogue()
	
	# Set up pause menu content
	var menu_content = {
		"instructions": "Defeat boss 1",
		"story": "Current story progress...",
		"task": "Current objectives:",
		"controls": "Movement: WASD\nJump: Space"
	}
	
	pause_menu.set_content(menu_content)
	pause_menu.close_menu()  # Start close
	

# Main menu -------------------------------------------
func _on_main_menu_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_main_menu = true
		main_menu_dialogue.show_text("Travel to main menu")
	
func _on_main_menu_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_main_menu = false
		main_menu_dialogue.hide_dialogue()

# Door one -------------------------------------------
func _on_door_1_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_1 = true
		portal1_dialogue.show_text("Travel to boss fight 1")

func _on_door_1_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_1 = false
		portal1_dialogue.hide_dialogue()
		
# Door two -------------------------------------------
func _on_door_2_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_2 = true
		if LevelManager.is_level_unlocked("level2"):
			portal2_dialogue.show_text("Travel to boss fight 2")
		else:
			portal2_dialogue.show_text("Locked - defeat boss 1")

func _on_door_2_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_2 = false
		portal2_dialogue.hide_dialogue()
		
# Door three -------------------------------------------
func _on_door_3_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_3 = true
		if LevelManager.is_level_unlocked("level3"):
			portal3_dialogue.show_text("Travel to boss fight 3")
		else:
			portal3_dialogue.show_text("Locked - defeat boss 2")

func _on_door_3_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_3 = false
		portal3_dialogue.hide_dialogue()

# Confirmation -------------------------------------------
func _input(event: InputEvent) -> void:
	
	# Main menu
	if player_in_main_menu and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/AlexisScenesAndScripts/main_menu.tscn")
	
	# Door one
	if player_in_door_1 and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer1.tscn")
		
	# Door one
	if player_in_door_2 and event.is_action_pressed("ui_accept"):
		if LevelManager.is_level_unlocked("level2"):
			get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer2.tscn")
		
	# Door one
	if player_in_door_3 and event.is_action_pressed("ui_accept"):
		if LevelManager.is_level_unlocked("level3"):
			get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer3.tscn")
