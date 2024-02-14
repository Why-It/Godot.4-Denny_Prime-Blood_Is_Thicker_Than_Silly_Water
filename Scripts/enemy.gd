extends CharacterBody2D

@export var EnemyType : int = 0
@onready var detection_range = $DetectionRange
@onready var melee_range = $MeleeRange
@onready var anim_player = $EnemyAnimPlayer
@onready var enemy_sprite = $EnemySprite
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var muzzle = $EnemySprite/Gun/Marker2D
@onready var gun_man = $"../../Player/gun_manager"

@onready var target = $Target
@onready var aim_timer = $AimTimer


@onready var nav_agent = $Nav/NavAgent
var target_node = null
var home_pos : Vector2


var enemy_health : int = 3
var is_dead : bool = false

@onready var win_condition = $".."

@export var enemySpeed : float = 185

@onready var audio_man = get_node("/root/AudioManager")

@onready var collider = $MeleeRange/CollisionShape2D
@onready var melee_range_area = $MeleeRange

@onready var anim_tree = $EnemyAnimTree


func _physics_process(_delta):
	if !has_death_played:
		
		if in_detection_range == true:
			SightCheck()
		
		if cur_state != "PatrolWaitForChange":
			if cur_state != "Attention":
				move_and_slide()
		AnimateEnemyMove()
		
		if !has_death_played:
			UpdateStateMachine()
		RotateEnemy()

func AnimateEnemyMove():
	if velocity != Vector2.ZERO:
		anim_tree.set("parameters/BlendSpace1D/blend_position", 1)
	else:
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)

func RecalcPath():
	#print("recalculating path")
	if target_node:
		nav_agent.target_position = target_node.global_position
		#print("recalc is target")
	else:
		pass
	#	nav_agent.target_position = home_pos
		#print("reclac is home")

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

func RotateEnemy():
	if target_node == null:
		pass
	else:
		#look_at(target_node.global_position)
		enemy_sprite.look_at((target_node.global_position))
		enemy_sprite.rotation_degrees += 90

func TakeDamage(dmg : int):
	enemy_health -= dmg
	#print("hit taken")
	if enemy_health <= 0:
		is_dead = true
		Death()


#MELEE RANGE
var in_melee_range : bool = false
var reached_point : bool = false

func _on_melee_range_body_entered(body):
	if body.is_in_group("Player"):
		in_melee_range = true
	elif body.is_in_group("PatrolPoint"):
		print("I'm here")
		reached_point = true

func _on_melee_range_body_exited(body):
	if body.is_in_group("Player"):
		in_melee_range = false
	elif body.is_in_group("PatrolPoint"):
		reached_point = false


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
		#in_detection_range = false
		pass



#State Machine YAY!

@export var patrol_points : Array[Node2D]

var cur_state : String

func _ready():
	
	audio_man.StopSong()
	audio_man.StartSong()
	
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 20
	nav_agent.target_desired_distance = 10
	
	
	#Enenmy starts in one of two beginning states. Once player gets their attention, it's a fight to the death.
	if patrol_points.size() > 0:
		cur_point = patrol_points[0]
		cur_point_array_pos = 0
		nav_agent.target_position = cur_point.global_position
		target_node = cur_point
		Patrol()
	else:
		Idle()

var axis = null

func UpdateStateMachine():
	
	if cur_state == "Patrol":
		if nav_agent.is_navigation_finished():
			if !continuous_patrol:
				PatrolWaitForChange()
			else:
				PatrolPointChange()
		else:
			axis = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = axis * (enemySpeed * patrol_speed_factor)
		
	
		
		#if reached_point:
		#	print("Changing Patrol point")
		#	PatrolPointChange()
	
	if detect_switch:
		init_target_to_player()
	if LoS:
		if cur_state == "Idle" || "Patrol":
			#target.set("global_position", player.global_position)
			pass
	else:
		if cur_state == "GetBetterPosition":
			#if nav_agent.is_navigation_finished():
			#	return
			axis = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = axis * enemySpeed
	
	if cur_state == "Chase":
		
		# Navmesh Shit
		#if nav_agent.is_navigation_finished():
		#	return
		axis = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = axis * enemySpeed
		
		if in_melee_range:
			AttackMelee()

func Idle():
	cur_state = "Idle"

var cur_point : Node2D
var cur_point_array_pos : int
@export var patrol_speed_factor : float = .45
@export var continuous_patrol : bool = false
@onready var patrol_timer : Node = $Nav/PatrolTimer
func Patrol():
	cur_state = "Patrol"


func PatrolPointChange():
	
	cur_state = "PatrolPointChange"
	
	reached_point = false
	
	if cur_point_array_pos == patrol_points.size()-1:
		cur_point_array_pos = 0
		cur_point = patrol_points[cur_point_array_pos]
	else:
		cur_point_array_pos += 1
		cur_point = patrol_points[cur_point_array_pos]
	
	nav_agent.target_position = cur_point.global_position
	target_node = cur_point
	Patrol()

func PatrolWaitForChange():
	cur_state = "PatrolWaitForChange"
	target_node = null
	velocity = Vector2.ZERO
	patrol_timer.start()


var has_att_played : bool = false

func Attention(): # Enemy stops for half a second then either chases or aims at player
	
	if !has_att_played:
		cur_state = "Attention"
		velocity = Vector2.ZERO
		#target.set("global_position", player.global_position)
		anim_player.queue("Attention!")
		audio_man.PlayAlert()
		has_att_played = true
		#pass onto the "animation has finished func

func Chase():
	cur_state = "Chase"
	

func AttackMelee():
	cur_state = "AttackMelee"
	
	velocity = axis * 0
	
	audio_man.PlaySwing()
	anim_player.play("enemy_melee")

@export var time_for_aiming : float = 1.25

func Aim(): # If the enemy has a LoS, aim for a couple frames then shoot. If they lose LoS, go to better position
	cur_state = "Aim"
	
	StopMovement()
	
	
	anim_player.queue("enemy_aim")
	aim_timer.start(time_for_aiming)
	#print(target_node)


func GetBetterPosition():
	cur_state = "GetBetterPosition"
	
	#print("Getting a better position!")

var aim_dir = Vector2.RIGHT

func AttackShoot():
	if !has_death_played:
		anim_player.queue("enemy_shoot_handgun")
		
		cur_state = "AttackShoot"
		
		aim_dir = global_position.direction_to(player.global_position)
		
		var radians = deg_to_rad(0.0)
		var b = bullet.instantiate()
		b.global_position = muzzle.global_position
		b.direction = aim_dir.rotated(radians)
		owner.add_child(b)
		b.was_fired_from_enemy = true
		
		Aim()

var has_death_played : bool = false
func Death():
	
	if !has_death_played:
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)
		cur_state = "Death"
		anim_player.stop()
		audio_man.PlayDie()
		anim_player.play("enemy_death")
		has_death_played = true
		
		melee_range_area.set_deferred("monitorable", false)
		gun_man.Increase_Spread_Value()
		#collider.set("disabled", true)
		
		win_condition.UpdateEnemyDeathCount()
		
		#print("dead")

func _on_aim_timer_timeout():
	#if cur_state == "Aim":
	if LoS:
		AttackShoot()
	else:
		GetBetterPosition()


func _on_enemy_anim_player_animation_finished(anim_name):
	
	if anim_name == "Attention!":
		if EnemyType == 0:
			Chase()
		if EnemyType == 1:
			Aim()
	
	if anim_name == "enemy_melee":
		
		if melee_range:
			player.TakeDamage(1)
		
		
		if EnemyType == 0:
			Chase()
		if EnemyType == 1:
			Aim()



func _on_recalculate_timer_timeout():
	RecalcPath()


var detect_switch : bool = false
var this_is_fucking_stupid = null

func _on_detection_range_area_entered(area):
	detect_switch = true
	this_is_fucking_stupid = area.owner


func init_target_to_player():
	if LoS == true:
		target_node = this_is_fucking_stupid

func StopMovement():
	if nav_agent.is_navigation_finished():
		return
	axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = Vector2(0,0)


func _on_patrol_timer_timeout():
	
	if cur_state == "PatrolWaitForChange":
		PatrolPointChange()
