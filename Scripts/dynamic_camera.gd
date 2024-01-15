extends Camera2D

const MAX_DISTANCE = 48

var target_distance = 0
var center_pos = position

@export var camera_target_factor : float = 2

func _process(_delta):
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	
	position = target_pos
	
func _input(event):
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / camera_target_factor
