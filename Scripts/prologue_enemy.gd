extends CharacterBody2D


const walk_speed = 175

@onready var nav_agent = $NavigationAgent2D
var cur_state : String
var axis = null
var target_node : Node

@onready var leg = $Legs
@onready var tors = $Torso
@onready var anim_player = $AnimationPlayer
@onready var audio_man = get_node("/root/AudioManager")

func _ready():
	Idle()
	self.set("visible", false)

func _process(_delta):
	if cur_state == "Walking":
		if !nav_agent.is_navigation_finished():
			move_and_slide()
			axis = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = axis * walk_speed
			
			leg.look_at(nav_agent.get_next_path_position())
			leg.rotation_degrees += 90
			tors.look_at(nav_agent.get_next_path_position())
			tors.rotation_degrees += 90
			
			anim_player.queue("Clyde_Walk")
		else:
			Idle()

func WalkToNode(node : Node):
	cur_state = "Walking"
	target_node = node
	nav_agent.target_position = node.global_position

func Idle():
	cur_state = "Idle"
	anim_player.stop()
	anim_player.queue("Clyde_Idle")
	velocity = Vector2.ZERO

func StandingTarget():
	cur_state = "Idle"
	audio_man.PlayAlert()
	anim_player.stop()
	anim_player.queue("Clyde_Idle")
	velocity = Vector2.ZERO

@export var pro_gun_man : Node

var isdead : bool = false

func Die():
	cur_state = "Dead"
	if !isdead:
		pro_gun_man.Increase_Spread_Value()
		anim_player.play("death")
		audio_man.PlayDie()
		isdead = true

func RecalcPath():
	#print("recalculating path")
	if target_node:
		nav_agent.target_position = target_node.global_position
		#print("recalc is target")
	else:
		pass


func _on_recalc_timer_timeout():
	RecalcPath()
