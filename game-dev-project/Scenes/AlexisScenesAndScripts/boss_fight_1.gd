extends Node2D

@onready var temp_boss_sprite = $CanvasLayer/BossAnimatedSprite2D
@onready var projectile_parent = $CanvasLayer

var BubbleScene = preload("res://Scenes/AlexisScenesAndScripts/bubble.tscn")
var TendrilScene = preload("res://Scenes/AlexisScenesAndScripts/Tendril.tscn")

func _ready():
	temp_boss_sprite.visible = false
	start_boss_appearance()

func start_boss_appearance():
	await get_tree().create_timer(5).timeout
	temp_boss_sprite.visible = true

	spawn_projectile_1()
	await get_tree().create_timer(3).timeout
	spawn_projectile_2()
	await get_tree().create_timer(5).timeout
	spawn_projectile_3()

# BUBBLE - goes straight down (Y axis) at X = 580
func spawn_projectile_1():
	var projectile = BubbleScene.instantiate()
	var start_pos = Vector2(580, -200)
	var end_pos = Vector2(580, 1200)
	projectile.position = start_pos
	projectile.z_index = 1
	projectile_parent.add_child(projectile)

	var tween = create_tween()
	tween.tween_property(projectile, "position", end_pos, 6.0).set_trans(Tween.TRANS_LINEAR)

# TENDRIL - goes straight right (X axis) at Y = 280 — updated X to -530
func spawn_projectile_2():
	var projectile = TendrilScene.instantiate()
	var start_pos = Vector2(-530, 280)
	var end_pos = Vector2(1500, 280)
	projectile.position = start_pos
	projectile.z_index = 1
	projectile_parent.add_child(projectile)

	var tween = create_tween()
	tween.tween_property(projectile, "position", end_pos, 6.0).set_trans(Tween.TRANS_LINEAR)

# BUBBLE - goes straight down (Y axis) at X = 440
func spawn_projectile_3():
	var projectile = BubbleScene.instantiate()
	var start_pos = Vector2(440, -250)
	var end_pos = Vector2(440, 1200)
	projectile.position = start_pos
	projectile.z_index = 1
	projectile_parent.add_child(projectile)

	var tween = create_tween()
	tween.tween_property(projectile, "position", end_pos, 6.0).set_trans(Tween.TRANS_LINEAR)
