extends CharacterBody2D

# Movement settings
var speed = 300
var jump_force = -600
var gravity = 1200

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement (left/right)
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	# Jump if on floor and pressing "ui_up"
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Move the player
	move_and_slide()
