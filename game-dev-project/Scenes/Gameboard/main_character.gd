extends CharacterBody2D

const TILE_SIZE = 64
const GRID_SIZE = 7
const HALF_GRID = GRID_SIZE / 2

# Min and max positions based on centered grid (e.g., from -3 to +3 tiles)
const MIN_POS = Vector2(-HALF_GRID, -HALF_GRID) * TILE_SIZE
const MAX_POS = Vector2(HALF_GRID, HALF_GRID) * TILE_SIZE

var is_moving = false
var move_duration = 0.1
var target_position: Vector2

func _ready():
	# Snap character to nearest tile position at start
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	target_position = position

func _process(_delta):
	if not is_moving:
		handle_input()

func handle_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_just_pressed("ui_up"):
		input_vector.y -= 1
	elif Input.is_action_just_pressed("ui_down"):
		input_vector.y += 1
	elif Input.is_action_just_pressed("ui_left"):
		input_vector.x -= 1
	elif Input.is_action_just_pressed("ui_right"):
		input_vector.x += 1

	if input_vector != Vector2.ZERO:
		var proposed_position = position + input_vector * TILE_SIZE

		# Check that the proposed position is within the board boundaries
		if proposed_position.x >= MIN_POS.x and proposed_position.x <= MAX_POS.x and proposed_position.y >= MIN_POS.y and proposed_position.y <= MAX_POS.y:
			move_to_tile(proposed_position)

func move_to_tile(destination: Vector2):
	is_moving = true
	target_position = destination
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished():
	is_moving = false
