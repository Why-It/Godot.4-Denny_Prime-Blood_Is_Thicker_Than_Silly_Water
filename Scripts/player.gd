extends CharacterBody2D

@export var gun_manager : Node

@export var character_speed : float = 200

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

func _ready():
	pass

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
