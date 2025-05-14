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

@onready var trophy_none = $TrophyProgress/TrophyNone
@onready var trophy1 = $TrophyProgress/Trophy1
@onready var trophy2 = $TrophyProgress/Trophy2
@onready var trophy3 = $TrophyProgress/Trophy3
@onready var trophy = $TrophyProgress
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
	trophy.modulate.a = 1.0
	
	book.position.y = 111 + MOVE_DISTANCE  # Start lower
	notes.position.y = 29 - MOVE_DISTANCE  # Start higher
	instructions.position.x = 9  # Start position
	trophy.position.x = -838.0
	
	book.visible = false
	notes.visible = false
	instructions.visible = true
	
	trophy_none.visible = false
	trophy1.visible = false
	trophy2.visible = false
	trophy3.visible = false
	
	if LevelManager.is_level_done("level3"):
		trophy3.visible = true
	elif LevelManager.is_level_done("level2"):
		trophy2.visible = true
	elif LevelManager.is_level_done("level1"):
		trophy1.visible = true
	else:
		trophy_none.visible = true

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
	
	# Animate trophies
	tween.parallel().tween_property(trophy, "position:x", -838.0 - MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(trophy, "modulate:a", 0.0, FADE_DURATION)

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
	
	# Animate trophies
	tween.parallel().tween_property(trophy, "position:x", -838.0, ANIM_DURATION)
	tween.parallel().tween_property(trophy, "modulate:a", 1.0, FADE_DURATION)
	print("2")
	
	# Animate instructions
	tween.parallel().tween_property(instructions, "position:x", 9, ANIM_DURATION)
	tween.parallel().tween_property(instructions, "modulate:a", 1.0, FADE_DURATION)
	
	
	tween.tween_callback(func(): 
		book.visible = false
		notes.visible = false
		emit_signal("menu_closed")
	)

func show_only_book_and_notes():
	if tween:
		tween.kill()

	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Animate instructions out (same as open_menu)
	tween.parallel().tween_property(instructions, "position:x", 9 + MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(instructions, "modulate:a", 0.0, FADE_DURATION)

	# Animate trophies out (same as open_menu)
	tween.parallel().tween_property(trophy, "position:x", -838.0 - MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(trophy, "modulate:a", 0.0, FADE_DURATION)

	# Ensure book and notes are visible and in final position
	book.visible = true
	notes.visible = true
	book.modulate.a = 1.0
	notes.modulate.a = 1.0
	book.position.y = 111
	notes.position.y = 29


func hide_all_for_transition():
	print("1")
	if tween:
		tween.kill()
	instructions.modulate.a = 0.0
	trophy.modulate.a = 0.0

	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Animate book out (same as close_menu)
	tween.parallel().tween_property(book, "position:y", 111 + MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(book, "modulate:a", 0.0, FADE_DURATION)

	# Animate notes out (same as close_menu)
	tween.parallel().tween_property(notes, "position:y", 29 - MOVE_DISTANCE, ANIM_DURATION)
	tween.parallel().tween_property(notes, "modulate:a", 0.0, FADE_DURATION)

	tween.tween_callback(func ():
		book.visible = false
		notes.visible = false
		instructions.visible = false
	)


func _input(event):
	if event.is_action_pressed("open-close_menu"):
		toggle_menu()
