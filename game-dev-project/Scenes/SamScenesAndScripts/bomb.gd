extends Node2D

@export var damage: int = 1
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64
var boss_position: Vector2
const THROW_DURATION: float = 2
const WARNING_DURATION: float = 1.0  # Time for warning flashes
const FUSE_TIME: float = 1.5        # Time after warning before explosion
const EXPLOSION_DURATION: float = 0.8

@onready var warning_sprite = $Sprite2D
@onready var bomb_sprite = $BombSprite
@onready var fuse_anim = $Fuse
@onready var explosion_anim = $DamageArea/Explosion
@onready var damage_area = $DamageArea
@onready var damage_collision = $DamageArea/CollisionShape2D

func _ready():
	# Initial setup - hide everything
	warning_sprite.visible = false
	bomb_sprite.visible = false
	fuse_anim.visible = false
	explosion_anim.visible = false
	damage_area.visible = false
	damage_collision.disabled = true
	
	# Start the attack sequence
	_throw_bomb()
	
	fuse_anim.play("default")

func _throw_bomb():
	# Show bomb at boss location
	bomb_sprite.visible = true
	bomb_sprite.global_position = boss_position
	
	# Animate bomb throw to target position
	var throw_tween = create_tween()
	throw_tween.set_trans(Tween.TRANS_QUAD)
	throw_tween.set_ease(Tween.EASE_OUT)
	throw_tween.tween_property(bomb_sprite, "global_position", global_position, THROW_DURATION)
	
	# Add throwing arc
	var arc_height = 100
	throw_tween.parallel().tween_property(bomb_sprite, "position:y", bomb_sprite.position.y - arc_height, THROW_DURATION/2).set_ease(Tween.EASE_OUT)
	throw_tween.parallel().tween_property(bomb_sprite, "position:y", -3, THROW_DURATION/2).set_delay(THROW_DURATION/2).set_ease(Tween.EASE_IN)
	
	await throw_tween.finished
	_show_warning_and_fuse()

func _show_warning_and_fuse():
	# Show warning at bomb location
	warning_sprite.global_position = global_position
	warning_sprite.visible = true
	
	# Start fuse animation
	fuse_anim.visible = true
	
	# Blink warning while fuse burns
	for i in 2:
		warning_sprite.modulate = Color.RED
		warning_sprite.modulate.a = 0.5
		await get_tree().create_timer(0.3).timeout
		warning_sprite.modulate = Color.TRANSPARENT
		await get_tree().create_timer(0.3).timeout
	
	warning_sprite.visible = false
	_explode()

func _explode():
	# Hide bomb and fuse, show explosion
	bomb_sprite.visible = false
	fuse_anim.visible = false
	explosion_anim.visible = true
	damage_area.visible = true
	
	# Play explosion and enable damage
	explosion_anim.play("default")
	damage_collision.disabled = false
	
	# Damage window
	await get_tree().create_timer(0.2).timeout
	damage_collision.disabled = true
	
	# Wait for explosion to finish
	await get_tree().create_timer(EXPLOSION_DURATION - 0.2).timeout
	queue_free()
