extends CharacterBody2D

@export var EnemyType : int = 0
@onready var detection_range = $DetectionRange
@onready var melee_range = $MeleeRange
@onready var anim_player = $EnemyAnimPlayer
@onready var enemy_sprite = $EnemySprite
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var muzzle = $EnemySprite/Gun/Marker2D

@onready var target = $Target
@onready var aim_timer = $AimTimer


@onready var nav_agent = $Nav/NavAgent
var target_node = null
var home_pos : Vector2


var enemy_health : int = 3
var is_dead : bool = false

@onready var win_condition = $".."

@export var enemySpeed : float = 185



func _physics_process(_delta):
	if !has_death_played:
		
		if in_detection_range == true:
			SightCheck()
		move_and_slide()
		if !has_death_played:
			UpdateStateMachine()
		RotateEnemy()

func RecalcPath():
	#print("recalculating path")
	if target_node:
		nav_agent.target_position = target_node.global_position
		#print("recalc is target")
	else:
		nav_agent.target_position = home_pos
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
		#in_detection_range = false
		pass



#State Machine YAY!

@export var patrol_points : Array

var cur_state : String

func _ready():
	
	
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	
	#Enenmy starts in one of two beginning states. Once player gets their attention, it's a fight to the death.
	if patrol_points.size() > 0:
		Patrol()
	else:
		Idle()

var axis = null

func UpdateStateMachine():
	
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
	
	

	
	#if cur_state == "Aim":
	#	if LoS:
	#		pass
	#	else:
	#		GetBetterPosition()
	
	#if is_dead:
	#	Death()

#Might need later idk

func Idle():
	cur_state = "Idle"

func Patrol():
	cur_state = "Patrol"


var has_att_played : bool = false

func Attention(): # Enemy stops for half a second then either chases or aims at player
	
	if !has_att_played:
		cur_state = "Attention"
		#target.set("global_position", player.global_position)
		anim_player.queue("Attention!")
		has_att_played = true
		#pass onto the "animation has finished func

func Chase():
	cur_state = "Chase"
	

func AttackMelee():
	cur_state = "AttackMelee"
	
	velocity = axis * 0
	
	anim_player.play("enemy_melee")

@export var time_for_aiming : float = 1.25

func Aim(): # If the enemy has a LoS, aim for a couple frames then shoot. If they lose LoS, go to better position
	cur_state = "Aim"
	
	StopMovement()
	
	
	anim_player.play("enemy_aim")
	aim_timer.start(time_for_aiming)
	#print(target_node)


func GetBetterPosition():
	cur_state = "GetBetterPosition"
	
	#print("Getting a better position!")

var aim_dir = Vector2.RIGHT

func AttackShoot():
	if !has_death_played:
		
		cur_state = "AttackShoot"
		#print("Bang")
		
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
		cur_state = "Death"
		anim_player.stop()
		anim_player.play("enemy_death")
		has_death_played = true
		
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
