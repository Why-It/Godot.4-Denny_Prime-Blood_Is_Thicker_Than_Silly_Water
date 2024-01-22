extends Area2D

var gun_man = Node
var direction = Vector2(1,0)
var speed = 650 # pixel/s

var was_fired_from_enemy : bool = false

func _ready():
	set_as_top_level(true)
	self.set("monitoring", true)

func _physics_process(delta):
	global_position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(_body):
	get_node("bullet_collisionshape").set_deferred("disabled", true)
#	if body.is_in_group("Enemies"):
#		#print("hit")
#		#gun_man.Increase_Spread_Value()
#	elif body.is_in_group("Player"):
#		body.PlayerTakeDamage(1)
#	#queue_free()
	self.hide()
	
	


func _on_area_entered(area):
	get_node("bullet_collisionshape").set_deferred("disabled", true)
	if area:
		if !was_fired_from_enemy:
			gun_man.Increase_Spread_Value()
			area.owner.EnemyTakeDamage()
		else:
			area.owner.PlayerTakeDamage(1)
	self.hide()
