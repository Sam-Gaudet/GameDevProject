extends RigidBody2D

const TILE_SIZE = 64
const GRID_SIZE = 7
const HALF_GRID = GRID_SIZE / 2
@onready var hide_timer := Timer.new()
@onready var gameoverTimer := Timer.new()
@onready var hearth1 = $"../camera/health/1"
@onready var health2 = $"../camera/health/2"
@onready var health3 = $"../camera/health/3"
@onready var blackscreen = $"../screen"
@onready var death_timer = $deathDelay
@onready var anim_player = $deathanimation
@onready var player = $Sprite2D

const MIN_POS = Vector2(-HALF_GRID, -HALF_GRID) * TILE_SIZE
const MAX_POS = Vector2(HALF_GRID, HALF_GRID) * TILE_SIZE

var is_moving = false
var move_duration = 0.1
var target_position: Vector2
var is_dead := false
var life := 3
var game_started := false

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	target_position = position
	hide_timer.wait_time = 5.0
	add_child(gameoverTimer)
	gameoverTimer.one_shot = true
	gameoverTimer.autostart = false
	gameoverTimer.wait_time = 4
	gameoverTimer.timeout.connect(_on_gameoverTimer_timeout)
	
	# Sam - Added this to handle my bomb parry
	add_to_group("player_attack")

func _process(_delta):
	if not is_moving and not is_dead and visible:
		handle_input()

func handle_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_just_pressed("move_up"):
		input_vector.y -= 1
	elif Input.is_action_just_pressed("move_down"):
		input_vector.y += 1
	elif Input.is_action_just_pressed("move_left"):
		input_vector.x -= 1
	elif Input.is_action_just_pressed("move_right"):
		input_vector.x += 1

	if input_vector != Vector2.ZERO:
		var proposed_position = position + input_vector * TILE_SIZE

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

func _on_hide_timer_timeout():
	visible = true
	is_moving = false

func _on_ouch_area_entered(area: Area2D):
	if area.is_in_group("projectile"):
		take_damage()


func take_damage():
	if is_dead:
		return

	life -= 1
	print("Player took damage! Life is now: ", life)
	match life:
		2:
			health3.visible = false
		1:
			health2.visible = false
		0:
			hearth1.visible = false

	if life == 0:
		is_dead = true
		blackscreen.visible = true
		death_timer.start()
		is_moving = true 
		gameoverTimer.wait_time = 2
	
func _on_death_delay_timeout():
	print("boom")
	player.visible = false
	anim_player.play("death")
	gameoverTimer.start()

func _on_gameoverTimer_timeout():
	print("done")
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
