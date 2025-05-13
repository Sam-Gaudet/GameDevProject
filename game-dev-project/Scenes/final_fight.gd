extends Node2D
@onready var fakeboss = $fakeboss
@onready var galactica = $galactica
@onready var fade = $FadeOverlay
var shake_timer = 0.0
var shake_strength = 5.0
#Testing
func _ready():
	Global.current_level = "3"
	await get_tree().create_timer(7.0).timeout
	fakeboss.play("die")
	await get_tree().create_timer(3.0).timeout
	real_boss_man()
	await get_tree().create_timer(8.0).timeout
	start_fight()

#Scenes import
@onready var ZoomSkullthing = preload("res://Scenes/boss projectiles/warning.tscn")
@onready var Skullthing = preload("res://Scenes/boss projectiles/Skulls.tscn")
@onready var WallSkullthing = preload("res://Scenes/boss projectiles/wall_skull.tscn")
@onready var ExplodingTile = preload("res://Scenes/boss projectiles/explosion.tscn")
@onready var flyingSkull = preload("res://Scenes/boss projectiles/flyingskull.tscn")
@onready var MinionScene = preload("res://Scenes/boss projectiles/minion.tscn")
@onready var ghost_scene = preload("res://Ghost.tscn")
@onready var minion_scene = preload("res://Scenes/boss projectiles/minion.tscn")
@onready var planet_scene := preload("res://Scenes/boss projectiles/divine_sword.tscn")
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
	[[0, 3], [0, 4], [1, 2], [1, 3], [1, 4], [2, 2], [2, 4], [3, 0], [3, 1], [3, 3], [3, 4], [4, 1], [4, 3], [4, 4], [5, 2], [5, 3], [5, 5], [6, 1], [6, 3], [6, 4], [1,6], [2,6], [3,6], [4,6] ],
	[[0, 0],[0, 1], [0, 2], [0, 3], [0, 4], [1, 1], [1, 3], [1, 5], [2, 1], [2, 2], [2, 4], [3, 0], [3, 2], [3, 5], [4, 1], [4, 3], [4, 4], [5, 0], [5, 2], [5, 4], [6, 2], [6, 5],[1,6], [2,6], [3,6], [5,6]]
]




func real_boss_man():
	galactica.visible = true
	var shake_duration = 3.0
	var shake_intensity = 10.0
	shake_nodes([$GameBoard, $fakeboss], 2.0, 4.0)  # Start shaking GameBoard

	var tween = create_tween()
	tween.tween_property(galactica, "global_position:y", 328, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	start_fade_to_white()


func shake_nodes(nodes: Array, duration: float, intensity: float) -> void:
	$AudioStreamPlayer2D.play()
	var original_positions = {}
	for node in nodes:
		original_positions[node] = node.position
	
	var timer := Timer.new()
	timer.wait_time = 0.05
	timer.one_shot = false
	add_child(timer)
	timer.start()

	var time_elapsed := 0.0
	while time_elapsed < duration:
		await timer.timeout
		for node in nodes:
			var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
			node.position = original_positions[node] + offset
		time_elapsed += timer.wait_time
	
	# Reset all node positions
	for node in nodes:
		node.position = original_positions[node]
	timer.queue_free()


func start_fade_to_white():
	var fade = $FadeOverlay
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 6.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)








func start_fight():
	fade.visible = false
	$GameBoard.modulate = Color(4, 4, 4, 0.5)
	galactica.z_index = -10
	fakeboss.visible = false
	$black.visible = false
	$CanvasLayer.visible = true
	start_multiple_waves()
	




#WAVES START
func start_multiple_waves():
	await spawn_waves(5, 1.5)
	await get_tree().create_timer(0.5).timeout
	await spawn_walls(10, 1)
	await get_tree().create_timer(1.0).timeout
	spawn_tile_explosions(5, 1.2)
	await get_tree().create_timer(6.0).timeout
	launch_planet_attack()
	await get_tree().create_timer(18).timeout
	trophy()






#SKULL WAVE
func spawn_waves(wave_count: int, delay: float) -> void:
	for i in range(wave_count):
		start_skulls_wave(i)
		if i == 2:
			spawn_zoom_skull(Vector2(580, 450))
			await get_tree().create_timer(2.0).timeout
			spawn_zoom_skull(Vector2(580, 180), true)
		await get_tree().create_timer(delay).timeout

func start_skulls_wave(wave_index: int) -> void:
	var pattern = wave_patterns[wave_index % wave_patterns.size()]
	for y_pos in pattern:
		spawn_skull("left", y_pos)
		await get_tree().create_timer(0.2).timeout  # slight delay between skulls
		spawn_skull("right", y_pos)
		await get_tree().create_timer(0.2).timeout

func spawn_skull(side: String, y_pos: float):
	var Skull = Skullthing.instantiate()

	if side == "left":
		Skull.global_position = Vector2(-10, y_pos)
		Skull.direction = Vector2.RIGHT
	elif side == "right":
		Skull.global_position = Vector2(1200, y_pos)
		Skull.direction = Vector2.LEFT
		Skull.scale.x *= -1
	Skull.base_speed = 200.0
	Skull.amplitude = randf_range(10.0, 40.0)
	Skull.frequency = randf_range(1.5, 3.0)
	add_child(Skull)










#SKULL WALL
func start_skull_wall(wall_index: int):
	var total_slots = 8
	var skull_spacing = (560 - 200) / total_slots

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





func launch_planet_attack():
	var planet1 = planet_scene.instantiate()
	planet1.position = Vector2(-100, 300)  # From left
	add_child(planet1)

	await get_tree().create_timer(3.0).timeout

	var planet2 = planet_scene.instantiate()
	planet2.position = Vector2(1200, 200)  # From right
	planet2.set_direction(Vector2(-1, 0.5))  # Angle toward center
	add_child(planet2)

func trophy():
	$trophy.position = Vector2(577, 296)
	await get_tree().create_timer(0.5)
	$trophy.visible = true
	$trophy.scale = Vector2(0.01, 0.01)  # Start tiny (almost invisible)
	$trophy.monitoring = true
	Global.last_level_completed = "Level3"
	
	LevelManager.unlock_level("gamecomplete")
	LevelManager.print_level_status()
	

	# Tween to normal size
	var tween = create_tween()
	tween.tween_property($trophy, "scale", Vector2(1, 1), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)



func _on_trophy_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
	# Scale up trophy
		var tween = create_tween()
		tween.tween_property($trophy, "scale", Vector2(6, 6), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


	# Wait, then hide/remove trophy
		await tween.finished
		$trophy.visible = false
		$trophy.monitoring = false  # Stop further triggers
