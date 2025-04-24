extends Camera2D


@onready var sprite_right = $AnimatedSprite2D2
@onready var hide_timer := Timer.new()
@onready var hero = get_node("../MainCharacter")

var target_rotation = 0.0
var rotation_speed = 0.1

var do_full_spin = false
var spin_duration = 2.0
var spin_timer = 0.0
var base_rotation = deg_to_rad(-50)
var spinning = false
var spin_start_rotation = base_rotation

func _ready():
	rotation = base_rotation
	do_full_spin = true



	# Set up and start the hide timer
	hide_timer.wait_time = 5.0
	hide_timer.one_shot = true
	add_child(hide_timer)
	hide_timer.start()
	hide_timer.timeout.connect(_on_hide_timer_timeout)

func _process(delta):
	# Handle full 360 spin
	if do_full_spin:
		if not spinning:
			spinning = true
			spin_timer = 0.0
			spin_start_rotation = rotation

		if spin_timer < spin_duration:
			spin_timer += delta
			var t = clamp(spin_timer / spin_duration, 0, 1)
			rotation = lerp_angle(spin_start_rotation, 0.0, t)
		else:
			rotation = 0.0
			do_full_spin = false
			spinning = false
	else:
		rotation = lerp_angle(rotation, deg_to_rad(target_rotation), rotation_speed)
		if abs(rotation - deg_to_rad(target_rotation)) < 0.001:
			rotation = deg_to_rad(target_rotation)

func _on_hide_timer_timeout():
	hero.visible = true
	var tween = create_tween()
	var new_position = position + Vector2(0, -60)
	tween.tween_property(self, "position", new_position, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
