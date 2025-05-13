extends Node2D

const SWORD_ATTACK = preload("res://Scenes/SamScenesAndScripts/sword.tscn")
const ARROW_ATTACK = preload("res://Scenes/SamScenesAndScripts/arrow.tscn")
const BOMB_ATTACK = preload("res://Scenes/SamScenesAndScripts/bomb.tscn")
const GRID_SIZE = 7
const TILE_SIZE = 64

@onready var boss_anim = %Boss
@onready var transition_rect = $Transition/TransitionRect
@onready var pause_menu = $PauseMenu/PauseMenu/PauseMenu

# Split attack patterns into different phases
var sword_arrow_pattern = [
	{"type": "sword", "direction": "row", "index": 0, "flip": false},
	{"type": "sword", "direction": "row", "index": 5, "flip": true},
	{"type": "sword", "direction": "row", "index": 6, "flip": false},
	{"type": "sword", "direction": "row", "index": 1, "flip": true},
	{"type": "sword", "direction": "row", "index": 2, "flip": false},
	{"type": "sword", "direction": "row", "index": 3, "flip": true},
	{"type": "sword", "direction": "row", "index": 4, "flip": false},
	{"type": "sword", "direction": "row", "index": 6, "flip": true},
	{"type": "sword", "direction": "row", "index": 1, "flip": false},
	
	{"type": "arrow", "direction": "row", "index": 2, "flip": false},
	{"type": "arrow", "direction": "row", "index": 3, "flip": true},
	{"type": "arrow", "direction": "row", "index": 6, "flip": false},
	{"type": "arrow", "direction": "row", "index": 4, "flip": true},
	{"type": "arrow", "direction": "row", "index": 1, "flip": false},
	{"type": "arrow", "direction": "row", "index": 4, "flip": true},
	{"type": "arrow", "direction": "row", "index": 3, "flip": false},
	{"type": "arrow", "direction": "row", "index": 5, "flip": true},
]

var bomb_pattern = [
	{"type": "bomb", "position": Vector2(3, 3)},
	{"type": "bomb", "position": Vector2(3, 2)},
	{"type": "bomb", "position": Vector2(1, 3)},
	{"type": "bomb", "position": Vector2(5, 4)},
]

var current_pattern_index = 0
var boss_health = 3
var is_boss_defeated = false
var is_in_bomb_phase = false

func _ready():
	LevelManager.print_level_status()
	# Start with black screen
	transition_rect.color = Color(0, 0, 0, 1)
	transition_rect.visible = true
	
	pause_menu.visible = true
	
	# Set up pause menu content
	var menu_content = {
		"instructions": "Defeat boss 1",
		"story": "Current story progress...",
		"task": "Dodge n stuff:",
		"controls": "Movement: WASD\nJump: Space"
	}
	
	pause_menu.set_content(menu_content)
	pause_menu.close_menu()  # Start close
	
	var fade_tween = create_tween()
	fade_tween.tween_property(transition_rect, "color:a", 0, 1.0)
	
	Global.current_level = "2"

	boss_anim.play("idle")
	await get_tree().create_timer(7.0).timeout
	start_attack_cycle()

func start_attack_cycle():
	# First phase: sword and arrow attacks
	for attack in sword_arrow_pattern:
		if is_boss_defeated:
			return
			
		spawn_attack(attack)
		await get_tree().create_timer(1.5).timeout
	
	# Second phase: continuous bomb attacks
	is_in_bomb_phase = true
	while boss_health > 0 and not is_boss_defeated:
		for attack in bomb_pattern:
			if is_boss_defeated:
				return
				
			spawn_attack(attack)
			await get_tree().create_timer(1.0).timeout  # Slightly faster bombs in loop

	if not is_boss_defeated:
		boss_defeated()

func spawn_attack(attack):
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

func boss_hit():
	boss_health -= 1
	boss_anim.play("hurt")
	print("Boss hit! Health: ", boss_health)
	
	# Return to idle after hurt animation
	await get_tree().create_timer(1).timeout
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
	$trophy.position = Vector2(0, 0)
	$trophy.visible = true
	$trophy.scale = Vector2(0.01, 0.01)
	$trophy.monitoring = true
	Global.last_level_completed = "Level2"
	
	LevelManager.unlock_level("level3")
	LevelManager.print_level_status()
	# Tween to normal size
	var tween = create_tween()
	tween.tween_property($trophy, "scale", Vector2(1, 1), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_trophy_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property($trophy, "scale", Vector2(6, 6), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await tween.finished
		$trophy.visible = false
		$trophy.monitoring = false
