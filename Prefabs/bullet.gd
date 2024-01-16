extends Area2D

var direction = Vector2(1,0)
var speed = 650 # pixel/s

func _ready():
	set_as_top_level(true)

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
