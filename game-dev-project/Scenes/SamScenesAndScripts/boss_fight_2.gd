extends Node2D

const SWORD_ATTACK = preload("res://Scenes/SamScenesAndScripts/sword.tscn")
const ARROW_ATTACK = preload("res://Scenes/SamScenesAndScripts/arrow.tscn")
const BOMB_ATTACK = preload("res://Scenes/SamScenesAndScripts/bomb.tscn")
const GRID_SIZE = 7
const TILE_SIZE = 64

@onready var boss_anim = %Boss

var attack_pattern = [
	{"type": "bomb", "position": Vector2(3, 2)},
	{"type": "bomb", "position": Vector2(1, 3)},
	{"type": "bomb", "position": Vector2(5, 4)},
	{"type": "sword", "direction": "row", "index": 0, "flip": false},
	{"type": "sword", "direction": "row", "index": 3, "flip": true},
	{"type": "arrow", "direction": "row", "index": 2, "flip": false},
	{"type": "arrow", "direction": "row", "index": 3, "flip": true},
	{"type": "bomb", "position": Vector2(3, 3)},
]
var current_pattern_index = 0
var boss_health = 3
var is_boss_defeated = false

func _ready():
	Global.current_level = "2"

	boss_anim.play("idle")
	await get_tree().create_timer(7.0).timeout
	start_attack_cycle()

func start_attack_cycle():
	while boss_health > 0 and not is_boss_defeated:
		var attack = attack_pattern[current_pattern_index]
		
		match attack["type"]:
			"sword":
				var sword = SWORD_ATTACK.instantiate()
				sword.GRID_SIZE = GRID_SIZE
				sword.TILE_SIZE = TILE_SIZE
				sword.direction = attack["direction"]
				sword.index = attack["index"]
				sword.flip = attack.get("flip", false)
				add_child(sword)
			
			"arrow":
				var arrow = ARROW_ATTACK.instantiate()
				arrow.GRID_SIZE = GRID_SIZE
				arrow.TILE_SIZE = TILE_SIZE
				arrow.direction = attack["direction"]
				arrow.index = attack["index"]
				arrow.flip = attack.get("flip", false)
				add_child(arrow)
			
			"bomb":
				var bomb = BOMB_ATTACK.instantiate()
				bomb.GRID_SIZE = GRID_SIZE
				bomb.TILE_SIZE = TILE_SIZE
				bomb.position = attack["position"] * TILE_SIZE - Vector2(GRID_SIZE/2, GRID_SIZE/2) * TILE_SIZE
				bomb.boss_position = boss_anim.global_position
				add_child(bomb)
		
		current_pattern_index = (current_pattern_index + 1) % attack_pattern.size()
		await get_tree().create_timer(3.0).timeout
	
	if not is_boss_defeated:
		boss_defeated()

func boss_hit():
	boss_health -= 1
	boss_anim.play("hurt")
	print("Boss hit! Health: ", boss_health)
	
	# Return to idle after hurt animation
	await get_tree().create_timer(1).timeout  # Match this to your hurt animation length
	if boss_health > 0:
		boss_anim.play("idle")
	else:
		boss_defeated()

func boss_defeated():
	is_boss_defeated = true
	clear_attacks()
	boss_anim.play("dead")
	print("BOSS DEFEATED!")
	win()

func clear_attacks():
	for child in get_children():
		if child.is_in_group("attack"):
			child.queue_free()


func win():
	Global.last_level_completed = "Level2"
	$trophy.position(0.0)
