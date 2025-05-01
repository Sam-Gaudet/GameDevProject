extends Node2D

#Testing
func _ready():
	await get_tree().create_timer(5.0).timeout
	start_multiple_waves()

#Scenes import
@onready var ZoomSkullthing = preload("res://Scenes/boss projectiles/warning.tscn")
@onready var Skullthing = preload("res://Scenes/boss projectiles/Skulls.tscn")
@onready var WallSkullthing = preload("res://Scenes/boss projectiles/wall_skull.tscn")
@onready var ExplodingTile = preload("res://Scenes/boss projectiles/explosion.tscn")
@onready var flyingSkull = preload("res://Scenes/boss projectiles/flyingskull.tscn")
@onready var GhostScene = preload("res://ghost.tscn")

#Pre set Pattern
var left_wall_patterns = [2, 4, 1, 3, 5, 2, 4, 3, 1, 5]
var right_wall_patterns = [4, 2, 5, 3, 1, 5, 2, 4, 1, 3]
var wave_patterns = [
	[150, 300, 450],
	[200, 400],
	[250, 350, 500],
	[180, 320, 460],
	[220, 340, 480]
]

#chat gpt is a real one
var explosion_patterns = [
	
	[[0, 1], [0, 2], [0, 4], [1, 3], [1, 4], [1, 5], [2, 0], [2, 1], [2, 3], [3, 0], [3, 1], [3, 2], [3, 5], [4, 1], [4, 2], [4, 4], [4, 5], [4, 6], [5, 0], [5, 1], [5, 3], [5, 4], [5, 5], [6, 0], [6, 3], [6, 5], [6, 6]],
	[[0, 2], [0, 3], [0, 4], [1, 2], [1, 3], [1, 5], [2, 0], [2, 2], [2, 4], [3, 4], [3, 5], [3, 6], [4, 1], [4, 3], [4, 5], [4, 6], [5, 1], [5, 3], [5, 4], [5, 6], [6, 0], [6, 1], [6, 2], [6, 4]],
	[[0, 0], [0, 1], [0, 2], [1, 1], [1, 2], [1, 3], [2, 2], [2, 3], [2, 4], [3, 2], [3, 3], [3, 4], [4, 1], [4, 2], [4, 3], [4, 5], [5, 0], [5, 1], [5, 2], [5, 3], [6, 0], [6, 2], [6, 3], [6, 5]],
	[[0, 3], [0, 4], [1, 2], [1, 3], [1, 4], [2, 2], [2, 4], [3, 0], [3, 1], [3, 3], [3, 4], [4, 1], [4, 3], [4, 4], [5, 2], [5, 3], [5, 5], [6, 1], [6, 3], [6, 4]],
	[[0, 0],[0, 1], [0, 2], [0, 3], [0, 4], [1, 1], [1, 3], [1, 5], [2, 1], [2, 2], [2, 4], [3, 0], [3, 2], [3, 5], [4, 1], [4, 3], [4, 4], [5, 0], [5, 2], [5, 4], [6, 2], [6, 5]]
]







func start_multiple_waves():
	await spawn_waves(5, 1.5)
	await get_tree().create_timer(0.5).timeout
	await spawn_walls(10, 1)
	await get_tree().create_timer(1.0).timeout
	spawn_tile_explosions(5, 1.0)
	await get_tree().create_timer(2.0).timeout
	await get_tree().create_timer(2.0).timeout
	spawn_ghost()


	
#SKULL WAVE
func spawn_waves(wave_count: int, delay: float) -> void:
	for i in range(wave_count):
		start_skulls_wave(i)
		if i == 2:
			spawn_zoom_skull(Vector2(580, 450))
			await get_tree().create_timer(2.0).timeout
			spawn_zoom_skull(Vector2(580, 180), true)
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
	var skull_spacing = (560 - 104) / total_slots

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
	var y_pos = 104 + slot_index * ((600 - 104) / 8)

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

#Zooming skull
func spawn_zoom_skull(position: Vector2, from_right := false):
	var skull = ZoomSkullthing.instantiate()
	skull.global_position = position
	if from_right:
		skull.scale.x *= -1
		skull.set("direction", Vector2.LEFT)
	else:
		skull.set("direction", Vector2.RIGHT)
	add_child(skull)






#Bombs and skull
func spawn_tile_explosions(repeat_count: int, delay: float) -> void:
	for i in range(repeat_count):
		await spawn_one_explosion_wave(i)
		await get_tree().create_timer(delay).timeout

func spawn_one_explosion_wave(wave_index: int) -> void:
	var tile_size = 64
	var start_x = 352
	var start_y = 104

	var pattern = explosion_patterns[wave_index % explosion_patterns.size()]

	for coord in pattern:
		var x_index = coord[0]
		var y_index = coord[1]
		var tile = ExplodingTile.instantiate()
		tile.global_position = Vector2(start_x + x_index * tile_size, start_y + y_index * tile_size)
		add_child(tile)



#roaming ghost
func spawn_ghost():
	var ghost = GhostScene.instantiate()
	ghost.global_position = Vector2(1200, 300)  # Off-screen right
	add_child(ghost)
