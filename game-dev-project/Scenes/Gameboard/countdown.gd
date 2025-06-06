extends Node2D

@onready var label3 = $"3"
@onready var label2 = $"2"
@onready var label1 = $"1"
@onready var label0 = $"go"


func _ready():
	label3.visible = false
	label2.visible = false
	label1.visible = false
	label0.visible = false


	await animate_label(label3)
	await animate_label(label2)
	await animate_label(label1)
	await animate_label(label0)

func animate_label(label: Label) -> void:
	label.visible = true
	$bonk.play()


	var tween = create_tween()
	var original_position = label.position
	tween.tween_property(label, "position", Vector2(-85, -224), 0.6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	await get_tree().create_timer(0.3).timeout

	var exit_position = Vector2(-10000, 0)
	var exit_tween = create_tween()
	exit_tween.tween_property(label, "position", exit_position, 0.6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	await exit_tween.finished
