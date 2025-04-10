extends Camera2D

var target_zoom = Vector2(1, 1)
var target_rotation = 0.0
var zoom_speed = 0.01
var rotation_speed = 0.1

func _ready():
	zoom = Vector2(0.5, 0.5)
	rotation = deg_to_rad(-50)

func _process(delta):
	zoom = zoom.lerp(target_zoom, zoom_speed)
	if abs(zoom.x - target_zoom.x) < 0.001 and abs(zoom.y - target_zoom.y) < 0.001:
		zoom = target_zoom
	
	rotation = lerp_angle(rotation, deg_to_rad(target_rotation), rotation_speed)
	if abs(rotation - deg_to_rad(target_rotation)) < 0.001:
		rotation = deg_to_rad(target_rotation)
