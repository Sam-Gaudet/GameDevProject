extends Node2D

var player_in_main_menu : bool = false
var player_in_door_1 : bool = false
var player_in_door_2 : bool = false
var player_in_door_3 : bool = false

# Dialogue / Pause menu
@onready var main_menu_dialogue = %Dialogue
@onready var pause_menu = $PauseMenu/PauseMenu/CanvasLayer

# Portal references
@onready var portal1_anim = $Door1/TestPortal
@onready var portal2_anim = $Door2/TestPortal
@onready var portal3_anim = $Door3/TestPortal

func _ready():
	#tranlation localization
	$Controls.text = tr("Controls")
	$ChessBoardControls.text = tr("ChessBoard")

	# Start all portal animations when the scene loads
	portal1_anim.play("portal")
	portal2_anim.play("portal")
	portal3_anim.play("portal")
	pause_menu.visible = true
	main_menu_dialogue.visible = false

# Main menu -------------------------------------------
func _on_main_menu_body_entered(body: Node2D) -> void:
	print("Do you want to go to the main menu")
	main_menu_dialogue.visible = true
	if body.name == "PlayerPlatformer":
		player_in_main_menu = true
	
func _on_main_menu_body_exited(body: Node2D) -> void:
	main_menu_dialogue.visible = false
	if body.name == "PlayerPlatformer":
		player_in_main_menu = false

# Door one -------------------------------------------
func _on_door_1_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_1 = true

func _on_door_1_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_1 = false
		
# Door two -------------------------------------------
func _on_door_2_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_2 = true

func _on_door_2_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_2 = false
		
# Door three -------------------------------------------
func _on_door_3_body_entered(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_3 = true

func _on_door_3_body_exited(body: Node2D) -> void:
	if body.name == "PlayerPlatformer":
		player_in_door_3 = false

# Confirmation -------------------------------------------
func _input(event: InputEvent) -> void:
	if pause_menu.visible and event.is_action_pressed("open-close_menu"):
		pause_menu.visible = false
		return
		
	if event.is_action_pressed("open-close_menu"):
		pause_menu.visible = not pause_menu.visible
		return
	
	# Main menu
	if player_in_main_menu and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/AlexisScenesAndScripts/main_menu.tscn")
	
	# Door one
	if player_in_door_1 and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer1.tscn")
		
	# Door one
	if player_in_door_2 and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer2.tscn")
		
	# Door one
	if player_in_door_3 and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer3.tscn")
