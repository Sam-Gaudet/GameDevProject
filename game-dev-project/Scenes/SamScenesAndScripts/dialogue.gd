# dialogue.gd
extends Node2D

@onready var dialogue_box = $DialogueLayer  # Your dialogue container
@onready var text_label = $DialogueLayer/DialogueDetails  # Your text label

var tween: Tween
var is_visible: bool = false
const FADE_DURATION = 0.3
const MOVE_DISTANCE = 50  # Same as pause menu animation

func _ready():
	# Set initial state (hidden)
	dialogue_box.modulate.a = 0
	dialogue_box.position.y = MOVE_DISTANCE  # Start lower
	dialogue_box.visible = false

func show_dialogue(text: String = ""):
	if is_visible:
		return
	
	is_visible = true
	dialogue_box.visible = true
	
	if text != "":
		text_label.text = text
	
	# Kill any existing tweens
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Animate dialogue box (move up and fade in)
	tween.parallel().tween_property(dialogue_box, "position:y", 0, FADE_DURATION)
	tween.parallel().tween_property(dialogue_box, "modulate:a", 1.0, FADE_DURATION)

func hide_dialogue():
	if !is_visible:
		return
	
	is_visible = false
	
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Animate dialogue box (move down and fade out)
	tween.parallel().tween_property(dialogue_box, "position:y", MOVE_DISTANCE, FADE_DURATION)
	tween.parallel().tween_property(dialogue_box, "modulate:a", 0.0, FADE_DURATION)
	
	tween.tween_callback(func(): 
		dialogue_box.visible = false
	)

# Helper function to show dialogue with text
func show_text(text: String):
	show_dialogue(text)
