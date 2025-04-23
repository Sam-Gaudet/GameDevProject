extends Node2D

@onready var label = $Label
@onready var restart_button = $restart
@onready var menu_button = $menu

func _ready():
	# Start transparent and disabled
	label.modulate.a = 0.0

	restart_button.modulate.a = 0.0
	restart_button.disabled = true

	menu_button.modulate.a = 0.0
	menu_button.disabled = true

	# Start the fade-in sequence
	show_fade_sequence()

func show_fade_sequence():
	var tween = create_tween()

	# Fade in label first
	tween.tween_property(label, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween = tween.chain()

	# Fade in restart button, then enable it
	tween.tween_property(restart_button, "modulate:a", 1.0, 1.0)
	tween.tween_callback(Callable(self, "_enable_restart_button"))
	tween = tween.chain()

	# Fade in menu button, then enable it
	tween.tween_property(menu_button, "modulate:a", 1.0, 1.0)
	tween.tween_callback(Callable(self, "_enable_menu_button"))

func _enable_restart_button():
	restart_button.disabled = false

func _enable_menu_button():
	menu_button.disabled = false
