extends CharacterBody2D

@onready var gun_manager : Node2D = $Torso/gun_manager

@export var character_speed : float = 200

#Animation Shit
#For Body

#For Head
@onready var head_animation_tree = $HeadAnimationTree
@onready var head_state_machine = head_animation_tree.get("parameters/playback")
#For Legs
#parameters/legs_motion/blend_position
@onready var legs_animation_tree = $LegsAnimationTree
@onready var legs_state_machine =  legs_animation_tree.get("parameters/playback")
#Rotating the player character's limbs
@export var player_legs : Node2D = null
@export var player_torso : Node2D = null

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
	rotateTorso()
	move_and_slide()
	pick_new_state()
	

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		legs_animation_tree.set("parameters/legs_motion/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		legs_animation_tree.set("parameters/legs_motion/blend_position", 1)
	else:
		legs_animation_tree.set("parameters/legs_motion/blend_position", 0)
		
	
func rotateLegs(player_rotation: Vector2):
	if player_rotation.x != 0 && player_rotation.y == 0:
		player_legs.rotation_degrees = 90
	else:
		player_legs.set("rotation", (-player_rotation.x * player_rotation.y))
	
func rotateTorso():
	player_torso.look_at(get_global_mouse_position())
	player_torso.rotation_degrees += 90
	
func _input(event):
	if event.is_action_pressed("Shoot"):
		gun_manager.Shoot()
