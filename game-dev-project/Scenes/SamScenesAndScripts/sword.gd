extends Node2D

@export var damage: int = 1
var direction: String = "row" # or "column"
var index: int = 0
var flip: bool = false # New flip parameter
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64
const SWORD_MOVE_DISTANCE: int = 40 # pixels to move

@onready var warning_sprite = $Sprite2D
@onready var damage_area = $DamageArea
@onready var sword_sprite = $DamageArea/Sprite2D
@onready var damage_collision = $DamageArea/CollisionShape2D

static var first_time := true

func _ready():
	# Initial setup
	damage_area.visible = false
	damage_collision.disabled = true
	sword_sprite.modulate.a = 0
	
	# Flip the entire attack if needed
	if flip:
		rotation_degrees = 180
	
	# Position based on attack direction
	if direction == "row":
		position = Vector2(0, (index - GRID_SIZE/2) * TILE_SIZE)
		sword_sprite.position.x = -SWORD_MOVE_DISTANCE
		damage_collision.position.x = -SWORD_MOVE_DISTANCE  # Match initial position
	else:
		position = Vector2((index - GRID_SIZE/2) * TILE_SIZE, 0)
		sword_sprite.position.y = -SWORD_MOVE_DISTANCE
		damage_collision.position.y = -SWORD_MOVE_DISTANCE  # Match initial position
	
	await _play_warning()
	if first_time:
		first_time = false
		queue_free()
	else:
		_attack()

func _play_warning():
	# Blink red twice
	for i in 2:
		warning_sprite.modulate = Color.RED
		warning_sprite.modulate.a = 0.5
		await get_tree().create_timer(0.3).timeout
		warning_sprite.modulate = Color.TRANSPARENT
		await get_tree().create_timer(0.3).timeout

func _attack():
	$AttackSound.play()
	warning_sprite.visible = false
	sword_sprite.visible = true
	damage_area.visible = true
	damage_collision.disabled = true
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	
	# Animate sword and collision movement
	if direction == "row":
		tween.tween_property(sword_sprite, "position:x", -50, 0.25)  # Sword moves to -50
		tween.parallel().tween_property(damage_collision, "position:x", 0, 0.25)  # Collision moves to 0
	else:
		tween.tween_property(sword_sprite, "position:y", 0, 0.25)
		tween.parallel().tween_property(damage_collision, "position:y", 0, 0.25)
	
	tween.parallel().tween_property(sword_sprite, "modulate:a", 1.0, 0.15)
	
	await tween.finished
	
	# Damage window - collision is now at (0,0)
	damage_collision.disabled = false
	await get_tree().create_timer(0.2).timeout
	damage_collision.disabled = true
	
	# Fade out
	var fade_tween = create_tween()
	fade_tween.tween_property(sword_sprite, "modulate:a", 0.0, 0.25)
	await fade_tween.finished
	
	queue_free()
