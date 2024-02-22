extends CharacterBody2D


const walk_speed = 175

var cur_state : String

@onready var tran_man = $"../../Transition"

@onready var leg = $Legs
@onready var tors = $Torso

func _ready():
	Idle()
	
	leg.rotation_degrees += 180
	tors.rotation_degrees += 180

var axis = null
@onready var nav_agent = $NavigationAgent2D

var target_node = null

func _physics_process(_delta):
	
	if cur_state == "WalkToNode()":
		if !nav_agent.is_navigation_finished():
			
			move_and_slide()
			axis = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = axis * walk_speed
			
			leg.look_at(nav_agent.get_next_path_position())
			leg.rotation_degrees += 90
			tors.look_at(nav_agent.get_next_path_position())
			tors.rotation_degrees += 90
		else:
			Idle()
	elif cur_state == "LookAtTarget()":
		move_and_slide()


func Idle():
	cur_state = "Idle()"
	StopMoving()

func WalkToNode(node : Node):
	cur_state = "WalkToNode()"
	
	target_node = node
	nav_agent.target_position = node.global_position

func StopMoving():
	velocity = Vector2.ZERO
	
	pass

func LookAtTarget(target : Node):
	cur_state = "LookAtTarget()"
	
	owner.look_at(target)

func Die():
	pass

func RecalcPath():
	#print("recalculating path")
	if target_node:
		nav_agent.target_position = target_node.global_position
		#print("recalc is target")
	else:
		pass

func _on_recalc_timer_timeout():
	RecalcPath()
