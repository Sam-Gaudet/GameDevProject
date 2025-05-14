extends Node2D

@export var damage: int = 1
var direction: String = "row" # Only row attacks now
var index: int = 0
var flip: bool = false
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64
const ARROW_SPEED: float = 1800.0 # pixels per second
const ARROW_DISTANCE: float = 800.0 # how far the arrow travels

@onready var warning_sprite = $Sprite2D
@onready var damage_area = $DamageArea
@onready var arrow_sprite = $DamageArea/Sprite2D
@onready var damage_collision = $DamageArea/CollisionShape2D

static var first_time := true

func _ready():
	# Initial setup
	damage_area.visible = false
	damage_collision.disabled = true
	arrow_sprite.modulate.a = 0
	
	# Position based on attack direction (exactly like sword)
	position = Vector2(0, (index - GRID_SIZE / 2) * TILE_SIZE)
	
	# Flip the entire attack if needed (like sword code)
	if flip:
		rotation_degrees = 180
	
	# Set initial positions outside the view
	arrow_sprite.position.x = -ARROW_DISTANCE
	damage_collision.position.x = -ARROW_DISTANCE # Match arrow's starting position
	arrow_sprite.rotation_degrees = 0 # Reset any sprite rotation
	
	await _play_warning()
	
	if first_time:
		first_time = false
		queue_free()
	else:
		_attack()

func _play_warning():
	# Blink red twice (same as sword)
	for i in 2:
		warning_sprite.modulate = Color.RED
		warning_sprite.modulate.a = 0.5
		await get_tree().create_timer(0.3).timeout
		warning_sprite.modulate = Color.TRANSPARENT
		await get_tree().create_timer(0.3).timeout

func _attack():
	$AttackSound.play()
	warning_sprite.visible = false
	arrow_sprite.visible = true
	damage_area.visible = true
	
	# Make arrow visible
	var appear_tween = create_tween()
	appear_tween.tween_property(arrow_sprite, "modulate:a", 1.0, 0.15)
	await appear_tween.finished
	
	# Enable damage collision immediately as arrow starts moving
	damage_collision.disabled = false
	
	# Calculate movement direction
	var target_position: Vector2 = Vector2(ARROW_DISTANCE, 0)
	
	# Calculate duration based on distance and speed
	var distance = ARROW_DISTANCE * 2 # Total travel distance
	var duration = distance / ARROW_SPEED
	
	# Animate both arrow and collision movement together
	var move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_LINEAR)
	move_tween.tween_property(arrow_sprite, "position", target_position, duration)
	move_tween.parallel().tween_property(damage_collision, "position", target_position, duration)
	
	await move_tween.finished
	
	# Disable damage and fade out
	damage_collision.disabled = true
	var fade_tween = create_tween()
	fade_tween.tween_property(arrow_sprite, "modulate:a", 0.0, 0.25)
	await fade_tween.finished
	
	queue_free()
