extends Node2D

@onready var bubble_template = preload("res://Scenes/AlexisScenesAndScripts/bubble.tscn")
@onready var tendril_template = preload("res://Scenes/AlexisScenesAndScripts/Tendril.tscn")

const GRID_SIZE = 7
const TILE_SIZE = 64

@onready var Dialogue_box = $Dialogue
@onready var Dialogue_sprite = $"Dialogue face"
@onready var boss_sprite = $CanvasLayer/BossAnimatedSprite2D
@onready var projectile_parent = $"."  # Or self, if you want to add them here

@onready var transition_rect = $Transition/TransitionRect
@onready var pause_menu = $PauseMenu/PauseMenu/PauseMenu

var attack_pattern = [
	{"type": "bubble", "position": Vector2(0, -500), "end_position": Vector2(0, 1200), "movement": "down"},
	{"type": "tendril", "position": Vector2(-700, 0), "end_position": Vector2(1500, 0), "movement": "right"},
	{"type": "bubble", "position": Vector2(190, -500), "end_position": Vector2(190, 1200), "movement": "down"},
	{"type": "tendril", "position": Vector2(-700, 65), "end_position": Vector2(1500, 65), "movement": "right"},
	
	# New combo attacks
	{"type": "combo", "attacks": [
		{"type": "bubble", "position": Vector2(65, -500), "end_position": Vector2(65, 1200), "movement": "down", "speed": 250},
		{"type": "tendril", "position": Vector2(-700, 130), "end_position": Vector2(1500, 130), "movement": "right"}
	]},
	{"type": "combo", "attacks": [
		{"type": "bubble", "position": Vector2(-65, -500), "end_position": Vector2(-65, 1200), "movement": "down", "speed": 300},
		{"type": "tendril", "position": Vector2(-700, 195), "end_position": Vector2(1500, 195), "movement": "right"}
	]},
]

var current_pattern_index = 0

func _ready():
	$Theme.play()
	LevelManager.print_level_status()
	# Start with black screen
	transition_rect.color = Color(0, 0, 0, 1)
	transition_rect.visible = true
	boss_sprite.visible = false
	start_boss_appearance()
	Global.current_level = "1"
	
	pause_menu.visible = true
	
	# Set up pause menu content
	var menu_content = {
		"story": "GameBoss1Story",
		"task" : "GameBoss1Task",
		"controls": "GameBoss1Controls",
		"instructions": "GameBoss1Instructions"
	}
	
	pause_menu.set_content(menu_content)
	pause_menu.close_menu()  # Start close
	
	var fade_tween = create_tween()
	fade_tween.tween_property(transition_rect, "color:a", 0, 1.0)

func start_boss_appearance():
	await get_tree().create_timer(5).timeout
	boss_sprite.visible = true
	spawn_attack_cycle()
	await get_tree().create_timer(5).timeout

func spawn_attack_cycle():
	for i in range(6):  # Loop through all 6 attacks
		var attack = attack_pattern[current_pattern_index]

		match attack["type"]:
			"bubble":
				spawn_bubble(attack)
			"tendril":
				spawn_tendril(attack)
			"combo":
				for sub_attack in attack["attacks"]:
					match sub_attack["type"]:
						"bubble":
							spawn_bubble(sub_attack)
						"tendril":
							spawn_tendril(sub_attack)

		current_pattern_index = (current_pattern_index + 1) % attack_pattern.size()
		await get_tree().create_timer(5.0).timeout
	
	win()

func spawn_bubble(attack):
	var bubble = bubble_template.instantiate()
	bubble.position = attack["position"]
	bubble.z_index = 1
	projectile_parent.add_child(bubble)

	var speed = attack.get("speed", 200)  # Default speed if not specified
	var distance = bubble.position.distance_to(attack["end_position"])
	var duration = distance / speed

	var tween = create_tween()
	tween.tween_property(bubble, "position", attack["end_position"], duration).set_trans(Tween.TRANS_LINEAR)

	await tween.finished
	if is_instance_valid(bubble):
		bubble.queue_free()

func spawn_tendril(attack):
	var tendril = tendril_template.instantiate()
	tendril.position = attack["position"]
	tendril.z_index = 1
	projectile_parent.add_child(tendril)

	var duration = 6.0  # Optional: make this configurable
	var tween = create_tween()
	tween.tween_property(tendril, "position", attack["end_position"], duration).set_trans(Tween.TRANS_LINEAR)

	await tween.finished
	if is_instance_valid(tendril):
		tendril.queue_free()

func clear_attacks():
	for child in projectile_parent.get_children():
		if child.is_in_group("attack"):  # Optional: tag them as "attack"
			child.queue_free()

func win():
	$trophy.position = Vector2(0, 0)
	$trophy.visible = true
	$trophy.scale = Vector2(0.01, 0.01)
	$trophy.monitoring = true
	Global.last_level_completed = "Level1"
	
	LevelManager.level_done("level1")	
	LevelManager.print_level_status()
	
	# Tween to normal size
	var tween = create_tween()
	tween.tween_property($trophy, "scale", Vector2(1, 1), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
