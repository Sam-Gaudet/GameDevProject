extends CharacterBody2D

# Movement settings
var speed = 300
var jump_force = -450
var gravity = 1200

# Animation
@onready var animated_sprite = $AnimatedSprite2D
var last_direction = 1  # 1 = right, -1 = left (default to facing right)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement (left/right)
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	# Update last direction when moving
	if direction != 0:
		last_direction = sign(direction)
	
	# Handle animations
	_update_animations(direction)
	
	# Jump if on floor and pressing "jump"
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		_play_directional_jump()

	# Move the player
	move_and_slide()

func _play_directional_jump():
	if last_direction > 0:
		animated_sprite.play("jump_right")
		animated_sprite.flip_h = false
	else:
		animated_sprite.play("jump_left")
		animated_sprite.flip_h = false

func _update_animations(direction):
	if not is_on_floor():
		# Update jump direction if changed mid-air
		if (last_direction > 0 and animated_sprite.animation != "jump_right") or \
		   (last_direction < 0 and animated_sprite.animation != "jump_left"):
			_play_directional_jump()
	elif direction > 0:  # Moving right
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = false
	elif direction < 0:  # Moving left
		animated_sprite.play("walk_left")
		animated_sprite.flip_h = false
	else:  # Not moving
		animated_sprite.play("idle")
		animated_sprite.flip_h = last_direction < 0
