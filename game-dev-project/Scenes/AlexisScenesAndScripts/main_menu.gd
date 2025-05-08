extends Control

@onready var main_menu = $CanvasLayer/MainMenuMarginContainer
@onready var options_menu = $CanvasLayer/SettingsMarginContainer
@onready var settings_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/MainMenuVboxContainer/Options
@onready var play_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/MainMenuVboxContainer/Play
@onready var quit_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/MainMenuVboxContainer/Exit
@onready var save_settings_button = $CanvasLayer/SettingsMarginContainer/VBoxContainer/SaveSettingsButton
@onready var master_label = $CanvasLayer/SettingsMarginContainer/VBoxContainer/MasterHBoxContainer/MasterLabel
@onready var music_label = $CanvasLayer/SettingsMarginContainer/VBoxContainer/MusicHBoxContainer2/MusicLabel
@onready var sfx_label = $CanvasLayer/SettingsMarginContainer/VBoxContainer/sfxHBoxContainer3/SFXLabel
@onready var english_button = %English
@onready var french_button = %French

func _ready():
	main_menu.visible = true
	options_menu.visible = false
	_update_localized_text()  # Load correct language on start

# Show settings, hide main menu
func _on_options_pressed() -> void:
	main_menu.visible = false
	options_menu.visible = true

# Hide settings, return to main menu
func _on_save_settings_button_pressed() -> void:
	options_menu.visible = false
	main_menu.visible = true

# Log and transition to game
func _on_play_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/SamScenesAndScripts/hub.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

# Language switching handlers
func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	_update_localized_text()

func _on_french_pressed():
	TranslationServer.set_locale("fr")
	_update_localized_text()

# Update all UI text based on current locale
func _update_localized_text():
	var play_text = tr("Play")
	var options_text = tr("Options")
	var quit_text = tr("Quit")
	var save_text = tr("SaveSettings")
	var english_text = tr("English")
	var french_text = tr("French")

	print("Translations:")
	print("Play:", play_text)
	print("Options:", options_text)
	print("Quit:", quit_text)
	print("SaveSettings:", save_text)
	print("English:", english_text)
	print("French:", french_text)

	play_button.text = play_text
	settings_button.text = options_text
	quit_button.text = quit_text
	save_settings_button.text = save_text
	english_button.text = english_text
	french_button.text = french_text
