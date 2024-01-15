extends Node2D

@export var animation_player = Node

var cur_weapon = null
var weapon_stack = [] #An array of weapons being held by the player
var weapon_indicator = 0
var next_weapon : String
var weapon_list = {}

@export var _weapon_resources : Array[shotgun_resource]

@export var start_weapons : Array[String]

func _ready():
	#Initilize(start_weapons) #enter state machine
	pass

func _input(event):
	pass
	#if event.is_action_pressed("Switch Next Weapon"):
	#	weapon_indicator = min(weapon_indicator+1, weapon_stack.size()-1)
	#	exit(weapon_stack[weapon_indicator])
		
	#if event.is_action_pressed("Switch Previous Weapon"):
	#	weapon_indicator = max(weapon_indicator-1, 0)
	#	exit(weapon_stack[weapon_indicator])

func Initilize(_start_weapons: Array):
	pass
	#for weapon in _weapon_resources:
	#	weapon_list[weapon.weapon_name] = weapon
		
	#for i in _start_weapons:
	#	weapon_stack.push_back(i) #Add out start weapon
	
	#cur_weapon = weapon_list[weapon_stack[0]] #set first item in the stack as the current weapon
	#enter()
	
func enter():
	pass
	#Call when first entering into a weapon#
	#animation_player.queue(cur_weapon.activate_anim)
	
func exit(_next_weapon: String):
	pass
	#in order to change weapons first call exit#
	#if _next_weapon != cur_weapon.weapon_name:
	#	if animation_player.get_current_animation() != cur_weapon.deactivate_anim:
	#		animation_player.play(cur_weapon.deactivate_anim)
	#		next_weapon = _next_weapon
	
func Change_Weapon(weapon_name: String):
	#cur_weapon = weapon_list[weapon_name]
	#next_weapon = ""
	#enter()
	pass
	


func _on_animation_player_animation_finished(anim_name):
	#if anim_name == cur_weapon.deactivate_anim:
	#	Change_Weapon(next_weapon)
	pass
