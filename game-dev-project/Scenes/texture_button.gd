extends Button


func _on_pressed() -> void:
	match Global.current_level:
		"1":
			get_tree().change_scene_to_file("res://Scenes/AlexisScenesAndScripts/boss_fight_1.tscn")
		"2":
			get_tree().change_scene_to_file("res://Scenes/SamScenesAndScripts/boss_fight_2.tscn")
		"3":
			get_tree().change_scene_to_file("res://Scenes/final_fight.tscn")



func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/AlexisScenesAndScripts/main_menu.tscn")
