extends CharacterBody2D

@export var EnemyType : int = 0
@onready var detection_range = $DetectionRange
@onready var melee_range = $MeleeRange
@onready var anim_player = $EnemyAnimPlayer
@onready var target = $Target

var enemy_health : int = 3
var is_dead : bool = false



func  _process(_delta):
	if in_detection_range == true:
		SightCheck()
	
	if !has_death_played:
		move_and_slide()
		UpdateStateMachine()
		look_at(target.global_position)

func EnemyTakeDamage():
	enemy_health -= 1
	#print("hit taken")
	if enemy_health <= 0:
		is_dead = true


#MELEE RANGE
var in_melee_range : bool = false

func _on_melee_range_body_entered(body):
	if body.is_in_group("Player"):
		in_melee_range = true

func _on_melee_range_body_exited(body):
	if body.is_in_group("Player"):
		in_melee_range = false

#DETETCTION RANGE
var player : Node
var LoS : bool = false
var in_detection_range : bool = false

func _on_area_2d_body_entered(body): #Enemy checks for if the plyer is in detection range
	if body.is_in_group("Player"):
		player = body
		in_detection_range = true

func _on_area_2d_body_exited(body): #Player leaving detection range
	if body.is_in_group("Player"):
		in_detection_range = false


func SightCheck():
	var space_state = get_world_2d().direct_space_state
	var sight_check = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(position, player.position, collision_mask, [self]))
	if sight_check:
		if sight_check.collider.name == "Player":
			LoS = true
			Attention()
			#print("LoS true")
		else:
			LoS = false
			#print("LoS false")

#State Machine YAY!

@export var patrol_points : Array

var cur_state : String

func _ready():
	
	#Enenmy starts in one of two beginning states. Once player gets their attention, it's a fight to the death.
	if patrol_points.size() > 0:
		Patrol()
	else:
		Idle()

func UpdateStateMachine():
	
	print(name + " is currently " + cur_state)
	
	if is_dead:
		Death()

#Might need later idk
"""
func EnterState(desiredState : String):
	pass

func ExitState(nextState : String):
	pass
"""
func Idle():
	cur_state = "Idle"

func Patrol():
	cur_state = "Patrol"


var has_att_played : bool = false

func Attention(): # Enemy stops for half a second then either chases or aims at player
	
	if !has_att_played:
		cur_state = "Attention"
		target.position = player.global_position
		anim_player.queue("Attention!")
		has_att_played = true

func Chase():
	cur_state = "Chase"

func AttackMelee():
	cur_state = "AttackMelee"

func Aim(): # If the enemy has a LoS, aim for a couple frames then shoot. If they lose LoS, go to better position
	cur_state = "Aim"

func GetBetterPosition():
	cur_state = "GetBetterPosition"

func AttackShoot():
	cur_state = "AttackShoot"

var has_death_played : bool = false
func Death():
	
	if !has_death_played:
		cur_state = "Death"
		anim_player.play("enemy_death")
		has_death_played = true
		
		print("dead")



