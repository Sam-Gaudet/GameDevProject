extends Node2D

@export var damage: int = 1
var GRID_SIZE: int = 7
var TILE_SIZE: int = 64
var boss_position: Vector2
var is_returning_to_boss: bool = false
var was_deflected: bool = false
var can_be_parried: bool = false
var player_in_parry_zone: bool = false
const THROW_DURATION: float = 2
const WARNING_DURATION: float = 1.0
const FUSE_TIME: float = 1.5
const EXPLOSION_DURATION: float = 0.8

@onready var warning_sprite = $Sprite2D
@onready var bomb_sprite = $BombSprite
@onready var fuse_anim = $Fuse
@onready var explosion_anim = $DamageArea/Explosion
@onready var damage_area = $DamageArea
@onready var damage_collision = $DamageArea/CollisionShape2D
@onready var parry_sound = $ParrySound
@onready var parry_area = $ParryArea
@onready var parry_collision = $ParryArea/CollisionShape2D

func _ready():
	warning_sprite.visible = false
	bomb_sprite.visible = false
	fuse_anim.visible = false
	explosion_anim.visible = false
	damage_area.visible = false
	damage_collision.disabled = true
	parry_area.visible = false
	parry_collision.disabled = true
	
	_throw_bomb()
	fuse_anim.play("default")

func _process(delta):
	if player_in_parry_zone and Input.is_action_just_pressed("ui_accept") and can_be_parried:
		deflect_bomb()

func _throw_bomb():
	bomb_sprite.visible = true
	bomb_sprite.global_position = boss_position
	
	var throw_tween = create_tween()
	throw_tween.set_trans(Tween.TRANS_QUAD)
	throw_tween.set_ease(Tween.EASE_OUT)
	throw_tween.tween_property(bomb_sprite, "global_position", global_position, THROW_DURATION)
	
	var arc_height = 15
	throw_tween.parallel().tween_property(bomb_sprite, "position:y", bomb_sprite.position.y - arc_height, THROW_DURATION/2).set_ease(Tween.EASE_OUT)
	throw_tween.parallel().tween_property(bomb_sprite, "position:y", 0, THROW_DURATION/2).set_delay(THROW_DURATION/2).set_ease(Tween.EASE_IN)
	
	await throw_tween.finished
	if !was_deflected:
		_activate_parry()
		_show_warning_and_fuse()

func _activate_parry():
	can_be_parried = true
	parry_area.visible = true
	parry_collision.disabled = false

func _show_warning_and_fuse():
	if is_returning_to_boss: 
		return
		
	warning_sprite.global_position = global_position
	warning_sprite.visible = true
	fuse_anim.visible = true
	
	for i in 2:
		if is_returning_to_boss:
			break
		warning_sprite.modulate = Color.RED
		warning_sprite.modulate.a = 0.5
		await get_tree().create_timer(0.3).timeout
		warning_sprite.modulate = Color.TRANSPARENT
		await get_tree().create_timer(0.3).timeout
	
	if !is_returning_to_boss:
		warning_sprite.visible = false
		_explode()

func _explode():
	#bomb/AttackSound.play()
	#$AudioStreamPlayer2D.play()
	print("Should play explosion sound")
	can_be_parried = false
	parry_area.visible = false
	parry_collision.disabled = true
	
	bomb_sprite.visible = false
	fuse_anim.visible = false
	explosion_anim.visible = true
	damage_area.visible = true
	
	explosion_anim.play("default")
	damage_collision.disabled = false
	
	await get_tree().create_timer(0.2).timeout
	damage_collision.disabled = true
	
	await get_tree().create_timer(EXPLOSION_DURATION - 0.2).timeout
	queue_free()

func deflect_bomb():
	if !can_be_parried:
		return
		
	was_deflected = true
	is_returning_to_boss = true
	parry_sound.play()
	
	# Immediately disable parry and hide warning
	can_be_parried = false
	parry_area.visible = false
	parry_collision.disabled = true
	warning_sprite.visible = false
	fuse_anim.visible = false
	
	# Store current position and calculate arc
	var start_pos = bomb_sprite.global_position
	var arc_height = 15  # Same as throw arc
	
	# Return to boss with identical arc movement
	var return_tween = create_tween()
	return_tween.set_trans(Tween.TRANS_QUAD)
	return_tween.set_ease(Tween.EASE_OUT)
	
	# First half of arc - going up
	return_tween.tween_property(bomb_sprite, "position:y", bomb_sprite.position.y - arc_height, THROW_DURATION/2).set_ease(Tween.EASE_OUT)
	# Second half of arc - coming down
	return_tween.parallel().tween_property(bomb_sprite, "position:y", 0, THROW_DURATION/2).set_delay(THROW_DURATION/2).set_ease(Tween.EASE_IN)
	# Horizontal movement
	return_tween.parallel().tween_property(bomb_sprite, "global_position", boss_position, THROW_DURATION)
	
	await return_tween.finished
	
	# Explosion at boss
	_explode_at_boss()
	get_parent().boss_hit()
	await get_tree().create_timer(EXPLOSION_DURATION).timeout
	queue_free()

func _explode_at_boss():
	# Hide bomb elements
	bomb_sprite.visible = false
	fuse_anim.visible = false
	
	# Reset explosion position relative to bomb
	explosion_anim.position = Vector2.ZERO
	damage_area.position = Vector2.ZERO
	
	# Move entire bomb node to boss position
	self.global_position = boss_position
	
	# Debug positions
	print("Exploding at boss position: ", boss_position)
	print("Explosion node position: ", explosion_anim.global_position)
	
	#$bomb/AttackSound.play()
	#$AudioStreamPlayer2D.play()
	# Make visible and play animation
	explosion_anim.visible = true
	damage_area.visible = true
	explosion_anim.play("default")
	damage_collision.disabled = false
	
	# Wait for animation to complete
	await get_tree().create_timer(EXPLOSION_DURATION).timeout
	
	# Disable collision after animation
	damage_collision.disabled = true

func _on_parry_area_area_entered(area: Area2D):
	if area.is_in_group("player_attack"):
		player_in_parry_zone = true
		
func _on_parry_area_area_exited(area: Area2D):
	if area.is_in_group("player_attack"):
		player_in_parry_zone = false
