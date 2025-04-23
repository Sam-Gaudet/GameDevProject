extends Node2D

var player_in_main_menu : bool = false
var player_in_door_1 : bool = false
var player_in_door_2 : bool = false
var player_in_door_3 : bool = false

# Main menu -------------------------------------------
func _on_main_menu_body_entered(body: Node2D) -> void:
	print("Do you want to go to the main menu")
	if body.name == "PlayerPlatformer":
		player_in_main_menu = true
	
func _on_main_menu_body_exited(body: Node2D) -> void:
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
	# Main menu
	if player_in_main_menu and event.is_action_pressed("ui_accept"):
		print("Switched to main menu")
	
	# Door one
	if player_in_door_1 and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer1.tscn")
		
	# Door one
	if player_in_door_2 and event.is_action_pressed("ui_accept"):
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/platformer2.tscn")
		
	# Door one
	if player_in_door_3 and event.is_action_pressed("ui_accept"):
		print("Switched to level 3")
