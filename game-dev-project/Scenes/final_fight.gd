extends Node2D

#Testing
func _ready():
	await get_tree().create_timer(5.0).timeout
	start_multiple_waves()
#Patterns
@onready var ZoomSkullthing = preload("res://Scenes/boss projectiles/warning.tscn")
@onready var Skullthing = preload("res://Scenes/boss projectiles/Skulls.tscn")
@onready var WallSkullthing = preload("res://Scenes/boss projectiles/wall_skull.tscn")

var left_wall_patterns = [2, 4, 1, 3, 5, 2, 4, 3, 1, 5]
var right_wall_patterns = [4, 2, 5, 3, 1, 5, 2, 4, 1, 3]
var wave_patterns = [
	[150, 300, 450],
	[200, 400],
	[250, 350, 500],
	[180, 320, 460],
	[220, 340, 480]
]

#SKULL WAVE
func start_multiple_waves():
	await spawn_waves(5, 1.5) 
	await get_tree().create_timer(0.5).timeout # Short pause
	await spawn_walls(10,1)

func spawn_waves(wave_count: int, delay: float) -> void:
	for i in range(wave_count):
		start_skulls_wave(i)
		if i == 2:
			spawn_zoom_skull()
		await get_tree().create_timer(delay).timeout

func start_skulls_wave(wave_index: int):
	var pattern = wave_patterns[wave_index % wave_patterns.size()]
	for y_pos in pattern:
		spawn_skull("left", y_pos)
		spawn_skull("right", y_pos)

func spawn_skull(side: String, y_pos: float):
	var Skull = Skullthing.instantiate()

	if side == "left":
		Skull.global_position = Vector2(-10, y_pos)
		Skull.direction = Vector2.RIGHT
	elif side == "right":
		Skull.global_position = Vector2(1200, y_pos)
		Skull.direction = Vector2.LEFT
		Skull.scale.x *= -1
	Skull.speed = 200.0
	Skull.amplitude = randf_range(10.0, 40.0)
	Skull.frequency = randf_range(1.5, 3.0)
	add_child(Skull)

#SKULL WALL
func start_skull_wall(wall_index: int):
	var total_slots = 8
	var skull_spacing = (552 - 104) / total_slots

	var left_gap = left_wall_patterns[wall_index % left_wall_patterns.size()]
	var right_gap = right_wall_patterns[wall_index % right_wall_patterns.size()]

	for i in range(total_slots):
		if i == left_gap or i == left_gap + 1:
			continue
		spawn_wall_skull(i, "left")

	await get_tree().create_timer(0.2).timeout

	for i in range(total_slots):
		if i == right_gap or i == right_gap + 1:
			continue
		spawn_wall_skull(i, "right")

func spawn_walls(wall_count: int, delay: float) -> void:
	for i in range(wall_count):
		await start_skull_wall(i)
		await get_tree().create_timer(delay).timeout

func spawn_wall_skull(slot_index: int, side: String):
	var y_pos = 104 + slot_index * ((552 - 104) / 8)

	var Skull = WallSkullthing.instantiate()
	Skull.position = Vector2(-10, y_pos) if side == "left" else Vector2(1200, y_pos)
	Skull.direction = Vector2.RIGHT if side == "left" else Vector2.LEFT

	if side == "right":
		Skull.scale.x *= -1

	Skull.speed = 300.0 
	Skull.amplitude = 0.0
	Skull.frequency = 0.0

	Skull.modulate = Color.GRAY

	add_child(Skull)

func spawn_zoom_skull():
	var zoom_skull = ZoomSkullthing.instantiate()
	zoom_skull.global_position = Vector2(600, 450)
	add_child(zoom_skull)
