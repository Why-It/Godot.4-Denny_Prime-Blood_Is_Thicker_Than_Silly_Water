extends Node2D

@export var anim_player : AnimationPlayer

var cur_weapon = null

var next_weapon : String
var prev_weapon : String

var weapon_stack = [] #An array of weapons being held by the player
var weapon_indicator = 0

var weapon_list = {} #Dictionary of all weapons available to use

@export var _weapon_resources : Array[shotgun_resource]
@export var starting_arsenal : Array[String]

func _ready():
	Initilize(starting_arsenal) #Enter the state machine
	
func _input(event):
	if event.is_action_released("Weapon_Next"):
		if weapon_indicator == weapon_stack.size()-1: # Roll over to the begginning of the array
			weapon_indicator = weapon_stack.size()-weapon_stack.size()
			exit(weapon_stack[weapon_indicator])
		else:
			weapon_indicator = min(weapon_indicator+1, weapon_stack.size()-1)
			exit(weapon_stack[weapon_indicator])
	
	if event.is_action_released("Weapon_Prev"):
		if weapon_indicator == weapon_stack.size()-weapon_stack.size(): # Roll over to the end of the array
			weapon_indicator = weapon_stack.size()-1
			exit(weapon_stack[weapon_indicator])
		else:
			weapon_indicator = max(weapon_indicator-1, 0)
			exit(weapon_stack[weapon_indicator])
		
	
func Initilize(_starting_arsenal : Array):
	
	#creating the dictionary
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	
	for i in _starting_arsenal:
		weapon_stack.push_back(i) #Add out start weapons
	
	cur_weapon = weapon_list[weapon_stack[0]]
	enter()
	
func enter(): #Call when entering the next weapon
	print(weapon_stack)
	anim_player.queue(cur_weapon.activate_anim)
	
func exit(_next_weapon : String): #Call before changing weapons
	if _next_weapon != cur_weapon.weapon_name:
		if anim_player.get_current_animation() != cur_weapon.deactivate_anim:
			anim_player.play(cur_weapon.deactivate_anim)
			next_weapon = _next_weapon
	
func Change_Weapon(weapon_name : String):
	cur_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == cur_weapon.deactivate_anim:
		Change_Weapon(next_weapon)
