extends Control

@onready var main_menu = $CanvasLayer/MainMenuMarginContainer
@onready var options_menu = $CanvasLayer/SettingsMarginContainer
@onready var settings_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/MainMenuVboxContainer/Options
@onready var save_settings_button = $CanvasLayer/SettingsMarginContainer/VBoxContainer/SaveSettingsButton
@onready var play_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/MainMenuVboxContainer/Play
@onready var exit_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/MainMenuVboxContainer/Exit

func _ready():
	# Start with main menu visible and settings menu hidden
	main_menu.visible = true
	options_menu.visible = false

	# Connect buttons to their respective handlers
	settings_button.pressed.connect(_on_settings_pressed)
	save_settings_button.pressed.connect(_on_save_settings_button_pressed)
	play_button.pressed.connect(_on_play_pressed)

# Show settings menu and hide main menu
func _on_settings_pressed() -> void:
	main_menu.visible = false
	options_menu.visible = true

# Hide settings menu and return to main menu
func _on_save_settings_button_pressed() -> void:
	options_menu.visible = false
	main_menu.visible = true

# Log play button press and start game scene (can be changed)
func _on_play_pressed() -> void:
	print("Play button pressed")
	get_tree().change_scene_to_file("res://dark_forest.tscn") # placeholder, change to proper scene
	

func _on_exit_pressed() -> void:
	get_tree().quit()
