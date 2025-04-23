extends Button


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gameboard/game_board.tscn")


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/AlexisScenesAndScripts/main_menu.tscn")
