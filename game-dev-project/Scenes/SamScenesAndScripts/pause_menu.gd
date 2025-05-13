# pause_menu.gd
extends CanvasLayer

signal menu_closed

@onready var book = $Book
@onready var notes = $Notes
@onready var instructions = $Insturctions
@onready var details_labels = {
	"instructions": $Insturctions/InstructionsDetails,
	"story": $Book/StoryDetails,
	"task": $Book/TaskDetails,
	"controls": $Book/ControlsDetails
}

var tween: Tween
var is_visible: bool = false
const ANIM_DURATION = 0.5
const FADE_DURATION = 0.3
const MOVE_DISTANCE = 50

func _ready():
	# Set initial state (hidden)
	book.modulate.a = 0
	notes.modulate.a = 0
	instructions.modulate.a = 1.0
	
	book.position.y = 111 + MOVE_DISTANCE  # Start lower
	notes.position.y = 29 - MOVE_DISTANCE  # Start higher
	instructions.position.x = 9  # Start position
	
	book.visible = false
	notes.visible = false
	instructions.visible = true

func set_content(content: Dictionary):
	for key in content:
		if key in details_labels and details_labels[key]:
			details_labels[key].text = content[key]

func toggle_menu():
	if is_visible:
		close_menu()
	else:
		open_menu()

func open_menu():
	if is_visible:
		return
	
	is_visible = true
	book.visible = true
	notes.visible = true
	
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Animate book (move up and fade in)
	tween.parallel().tween_property(book, "position:y", 111, ANIM_DURATION)
	tween.parallel().tween_property(book, "modulate:a", 1.0, FADE_DURATION)
	
	# Animate notes (move down and fade in)
	tween.parallel().tween_property(notes, "position:y", 29, ANIM_DURATION)
	tween.parallel().tween_property(notes, "modulate:a", 1.0, FADE_DURATION)
	
	# Animate instructions (move left and fade out)
	tween.parallel().tween_property(instructions, "position:x", 9 + MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(instructions, "modulate:a", 0.0, FADE_DURATION)

func close_menu():
	if !is_visible:
		return
	
	is_visible = false
	
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Animate book (move down and fade out)
	tween.parallel().tween_property(book, "position:y", 111 + MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(book, "modulate:a", 0.0, FADE_DURATION)
	
	# Animate notes (move up and fade out)
	tween.parallel().tween_property(notes, "position:y", 29 - MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(notes, "modulate:a", 0.0, FADE_DURATION)
	
	# Animate instructions (move right and fade in)
	tween.parallel().tween_property(instructions, "position:x", 9, ANIM_DURATION)
	tween.parallel().tween_property(instructions, "modulate:a", 1.0, FADE_DURATION)
	
	tween.tween_callback(func(): 
		book.visible = false
		notes.visible = false
		emit_signal("menu_closed")
	)

func show_only_book_and_notes():
	# Hide instructions completely
	instructions.visible = false
	instructions.modulate.a = 0
	instructions.position.x = 9 + MOVE_DISTANCE
	
	# Ensure book and notes are visible
	book.visible = true
	notes.visible = true
	book.modulate.a = 1.0
	notes.modulate.a = 1.0
	book.position.y = 111
	notes.position.y = 29

func hide_all_for_transition():
	# Immediately hide all UI elements without animation
	if tween:
		tween.kill()
	
	book.visible = false
	notes.visible = false
	instructions.visible = false
	
	# Reset properties for next time
	book.modulate.a = 0
	notes.modulate.a = 0
	instructions.modulate.a = 0
	
	book.position.y = 111 + MOVE_DISTANCE
	notes.position.y = 29 - MOVE_DISTANCE
	instructions.position.x = 9 + MOVE_DISTANCE

func _input(event):
	if event.is_action_pressed("open-close_menu"):
		toggle_menu()
