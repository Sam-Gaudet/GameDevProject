extends Node2D

@export var laser_scene = load("res://Scenes/boss projectiles/laser.tscn")
@export var BombScene = preload("res://Scenes/boss projectiles/bomb.tscn")
@export var number_of_lasers: int = 12
@export var radius: float = 200
@export var delay_between_spawns: float = 0.2
@export var bomb_spawn_delay: float = 0.5 # slower for dramatic effect

const GRID_SIZE := 7
const TILE_SIZE := 64
const CENTER_POSITION := Vector2(576, 328) # updated center of grid

var angle_step := 0.0
var current_index := 0
var current_laser: Node2D = null

func _ready():
	angle_step = TAU / number_of_lasers
	start_laser_rotation_delayed()

func start_laser_rotation_delayed():
	await get_tree().create_timer(6.0).timeout
	start_laser_rotation()

func start_laser_rotation():
	spawn_lasers_sequentially()
	await get_tree().create_timer(1.0).timeout # slight buffer before bomb wave


func spawn_lasers_sequentially():
	current_index = 0
	_spawn_next_laser()

func _spawn_next_laser():
	if current_laser and is_instance_valid(current_laser):
		current_laser.queue_free()

	var angle = angle_step * current_index
	var laser = laser_scene.instantiate() as Node2D
	laser.rotation = angle
	laser.position = CENTER_POSITION + Vector2(cos(angle), sin(angle)) * radius

	add_child(laser)
	current_laser = laser

	current_index = (current_index + 1) % number_of_lasers
	await get_tree().create_timer(delay_between_spawns).timeout
	_spawn_next_laser()
