extends CharacterBody2D

@onready var gun_manager : Node = $gun_manager

@export var character_speed : float = 200
@export var player_health : int = 1

@export var player_max_health : int = 2
@export var player_min_health : int = 0

#Animation Shit
#For Body
@onready var body_animation_tree = $BodyAnimationTree
#For Legs
#parameters/legs_motion/blend_position
@onready var legs_animation_tree = $LegsAnimationTree
@onready var legs_state_machine =  legs_animation_tree.get("parameters/playback")
#Rotating the player character's limbs
@export var player_legs : Node2D = null
@export var player : Node2D = null
#rotating gun collidider
@onready var player_collider : Node = $PlayerCollider
#Rotating the indicator arrow towards the level exit
@onready var arrow : Node = $Sprite2D
@export var level_leave_node = Node

@onready var transition : Node = $"../../Transition"

@onready var gui = $"../../GUI"

@onready var audio_man = get_node("/root/AudioManager")

var is_player_dead : bool = false

func _ready():
	player_health = player_max_health
	isArrow_on = false

func _physics_process(_delta):
	var inputDirection = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	
	inputDirection = inputDirection.normalized()
	velocity = inputDirection * character_speed
	
	update_animation_parameters(inputDirection)
	rotateLegs(inputDirection)
	rotatePlayer()
	move_and_slide()
	pick_new_state()
	
	if isArrow_on:
		rotateArrow()
	
	if player_health <= player_min_health:
		pass
	
	if gun_manager == null:
		print("gun_manager is null (player)")

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		legs_animation_tree.set("parameters/legs_motion/blend_position", move_input)
		body_animation_tree.set("parameters/body_motion/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		legs_animation_tree.set("parameters/legs_motion/blend_position", 1)
		body_animation_tree.set("parameters/body_motion/blend_position", 1)
	else:
		legs_animation_tree.set("parameters/legs_motion/blend_position", 0)
		body_animation_tree.set("parameters/body_motion/blend_position", 0)
	
func rotateLegs(player_rotation: Vector2):
	if player_rotation.x != 0 && player_rotation.y == 0:
		player_legs.global_rotation_degrees = 90
	else:
		player_legs.set("global_rotation", (-player_rotation.x * player_rotation.y))
	
func rotatePlayer():
	player.look_at(get_global_mouse_position())
	player.rotation_degrees += 90
	gun_manager.look_at(get_global_mouse_position())
	gun_manager.rotation_degrees += 90
	player_collider.look_at(get_global_mouse_position())
	player_collider.rotation_degrees += 42.5

var isArrow_on : bool = false
func rotateArrow():
	arrow.look_at(level_leave_node.global_position)
	arrow.rotation_degrees += 90

func toggleArrow():
	isArrow_on = !isArrow_on
	if !arrow.get("visible") && isArrow_on:
		arrow.set("visible", true)
	else:
		arrow.set("visible", false)

func TakeDamage(damage : int):
	player_health -= damage
	
	
	if player_health <= player_min_health:
		PlayerDeath()
	else:
		audio_man.PlayHurt()

func PlayerDeath():
	audio_man.PlayDie()
	is_player_dead = true
	gui.ToggleDeathUI()
