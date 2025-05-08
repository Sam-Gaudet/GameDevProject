extends Node2D

@onready var bubble_template = preload("res://Scenes/AlexisScenesAndScripts/bubble.tscn")
@onready var tendril_template = preload("res://Scenes/AlexisScenesAndScripts/Tendril.tscn")

const GRID_SIZE = 7
const TILE_SIZE = 64

@onready var Dialogue_box = $Dialogue
@onready var Dialogue_sprite = $"Dialogue face"
@onready var boss_sprite = $CanvasLayer/BossAnimatedSprite2D
@onready var projectile_parent = $"."  # Or self, if you want to add them here

var attack_pattern = [
	{"type": "bubble", "position": Vector2(0, -500), "end_position": Vector2(0, 1200), "movement": "down"},
	{"type": "tendril", "position": Vector2(-700, 0), "end_position": Vector2(1500, 0), "movement": "right"},
	{"type": "bubble", "position": Vector2(190, -500), "end_position": Vector2(190, 1200), "movement": "down"},
	{"type": "tendril", "position": Vector2(-700, 65), "end_position": Vector2(1500, 65), "movement": "right"},

]

var current_pattern_index = 0

func _ready():
	Dialogue_box.visible = false
	Dialogue_sprite.visible = false
	boss_sprite.visible = false
	start_boss_appearance()
	Global.current_level = "1"

func start_boss_appearance():
	await get_tree().create_timer(5).timeout
	boss_sprite.visible = true
	Dialogue_sprite.visible = true
	Dialogue_box.visible = true


	spawn_attack_cycle()
	await get_tree().create_timer(5).timeout

func spawn_attack_cycle():
	for i in range(4):  # Loop through the pattern 4 times
		var attack = attack_pattern[current_pattern_index]

		match attack["type"]:
			"bubble":
				spawn_bubble(attack)
			"tendril":
				spawn_tendril(attack)

		current_pattern_index = (current_pattern_index + 1) % attack_pattern.size()
		await get_tree().create_timer(3.0).timeout


func spawn_bubble(attack):
	var bubble = bubble_template.instantiate()
	bubble.position = attack["position"]
	bubble.z_index = 1
	projectile_parent.add_child(bubble)  # Add dynamically as child

	var tween = create_tween()
	tween.tween_property(bubble, "position", attack["end_position"], 6.0).set_trans(Tween.TRANS_LINEAR)

func spawn_tendril(attack):
	var tendril = tendril_template.instantiate()
	tendril.position = attack["position"]
	tendril.z_index = 1
	projectile_parent.add_child(tendril)  # Add dynamically as child

	var tween = create_tween()
	tween.tween_property(tendril, "position", attack["end_position"], 6.0).set_trans(Tween.TRANS_LINEAR)



func clear_attacks():
	for child in projectile_parent.get_children():
		if child.is_in_group("attack"):  # Optional: tag them as "attack"
			child.queue_free()

func win():
	Global.last_level_completed = "Level2"
	$trophy.position = Vector2(0, 0)
