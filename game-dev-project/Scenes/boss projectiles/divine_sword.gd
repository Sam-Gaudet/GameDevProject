extends Area2D

@export var speed: float = 300.0
var direction := Vector2(1, 0.7).normalized()
var exploding := false
var explode_timer := 13.0
var initial_speed := 320.0

# Arena bounds
@export var min_x := 120
@export var max_x := 1100
@export var min_y := 10
@export var max_y := 500

@onready var anim_player := $AnimatedSprite2D  # Adjust this to your node's name if needed

func _ready():
	position = Vector2(-100, 300)  # Start off-screen to the left
	set_process(true)
	position = position

func _process(delta):
	if exploding:
		return

	# Movement
	position += direction * speed * delta

	# Bounce on arena bounds
	if position.x < min_x or position.x > max_x:
		direction.x *= -1
		position.x = clamp(position.x, min_x, max_x)
	if position.y < min_y or position.y > max_y:
		direction.y *= -1
		position.y = clamp(position.y, min_y, max_y)

	# Countdown and color/speed transition
	explode_timer -= delta
	var t: float = clamp(1.0 - (explode_timer / 5.0), 0.0, 1.0)
	speed = lerp(initial_speed, 50.0, t)
	modulate = Color(1.0, 1.0 - (0.7 * t), 1.0 - (0.7 * t))  # Slowly turns red

	if explode_timer <= 0.0:
		boom()

func _physics_process(delta):
	# Bounce off other planets
	for body in get_overlapping_bodies():
		if body is Area2D and body.name == "planet":
			direction = (position - body.position).normalized()

# Explosion animation
func boom():
	if exploding:
		return
	exploding = true
	$planet.visible = false
	anim_player.play("boom")
	await anim_player.animation_finished
	queue_free()

# Set direction of the planet
func set_direction(dir: Vector2):
	direction = dir.normalized()

# Detect if an area enters the planet's area
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("planet") and area != self:
		var collision_vector = (position - area.position).normalized()
		direction = collision_vector
