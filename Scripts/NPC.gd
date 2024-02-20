extends CharacterBody2D


const walk_speed = 300.0

	

func _physics_process(_delta):
	pass

func UpdateStateMachine():
	pass

func Idle():
	pass

func WalkToNode():
	move_and_slide()

func StopMoving():
	pass

func LookAtTarget(target : Node):
	owner.look_at(target)

func Die():
	pass

