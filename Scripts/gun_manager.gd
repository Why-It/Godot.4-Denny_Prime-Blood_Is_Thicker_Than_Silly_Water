extends Node2D

@export var anim_player : AnimationPlayer

#Shotgun Shooty Stuff
@export var bullet : PackedScene
@onready var muzzle : Node2D = $Muzzle
var aim_dir = Vector2.RIGHT
var cur_ammo : int
var cur_reserve : int

@export var _weapon_resources : Array[shotgun_resource]
var cur_weapon = null

#weaopon switchy stuff
var next_weapon : String
var prev_weapon : String
var weapon_stack = [] #An array of weapons being held by the player
var weapon_indicator = 0
var weapon_list = {} #Dictionary of all weapons available to use
@export var starting_arsenal : Array[String]

#Shotgun Spread Stuff
#@export var spread : float
@export var spread_shower : Node

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
	
	if event.is_action_pressed("Shoot"):
		Shoot()
	
	if event.is_action_pressed("Reload"):
		Reload()

func Initilize(_starting_arsenal : Array):
	
	#creating the dictionary
	for weapon in _weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	
	for i in _starting_arsenal:
		weapon_stack.push_back(i) #Add out start weapons
	
	cur_weapon = weapon_list[weapon_stack[0]]
	enter()
	
	#print(weapon_list)


func _physics_process(_delta):
	aim_dir = global_position.direction_to(get_global_mouse_position())
	
	for shotgun in _weapon_resources:
		if shotgun.pellet_spread > 0.5:
			shotgun.pellet_spread -= 0.1 * shotgun.spread_recover_speed * _delta
			
			if shotgun.pellet_spread < shotgun.spread_min:
				shotgun.pellet_spread = 0.5
			
			#print(shotgun.weapon_name + " spread is "+ str(shotgun.pellet_spread))
	
	UpdateAmmo()
	Spread_Shower_Update()

func UpdateAmmo():
	cur_ammo = cur_weapon.loaded_ammo
	cur_reserve = cur_weapon.reserve_ammo

func enter(): #Call when entering the next weapon
	anim_player.queue(cur_weapon.activate_anim)
	anim_player.queue(cur_weapon.idle_anim)
	cur_ammo = cur_weapon.loaded_ammo
	cur_reserve = cur_weapon.reserve_ammo
	#print(cur_weapon.reserve_ammo)
	#print("current animation: " + str(anim_player.get_current_animation()))


func exit(_next_weapon : String): #Call before changing weapons
	if _next_weapon != cur_weapon.weapon_name:
		if anim_player.get_current_animation() != cur_weapon.deactivate_anim:
			anim_player.play(cur_weapon.deactivate_anim)
			next_weapon = _next_weapon
	
func Change_Weapon(weapon_name : String):
	#print(weapon_list[weapon_name])
	cur_weapon = weapon_list[weapon_name]
	#print(weapon_list[weapon_name])
	next_weapon = ""
	enter()

func Increase_Spread_Value():
	if cur_weapon.pellet_spread < cur_weapon.spread_max:
		cur_weapon.pellet_spread += 0.5

func Spread_Shower_Update():
	spread_shower.set("value", cur_weapon.pellet_spread * 100.5)

func Reload():
	if anim_player.get_current_animation() == cur_weapon.idle_anim:
		if cur_weapon.reserve_ammo > 0:
			if cur_weapon.loaded_ammo < cur_weapon.max_loaded_ammo:
				
				print("RELOADING!!!!")
				anim_player.stop()
				
				#Double Barrel Unique reload sequence
				if cur_weapon.weapon_name == "Double":
					if cur_weapon.loaded_ammo > 0:
						anim_player.queue(cur_weapon.dbs_reload_half)
						cur_weapon.loaded_ammo += 1
					else:
						anim_player.queue(cur_weapon.dbs_reload_full)
						cur_weapon.loaded_ammo += 2
				else: #The other shotguns
					anim_player.queue(cur_weapon.reload_anim)
					cur_weapon.loaded_ammo += 1
				
				anim_player.queue(cur_weapon.idle_anim)
				#print("Current Ammo in Shotgun: " + str(cur_weapon.loaded_ammo))

func Shoot():
	if cur_weapon.loaded_ammo > 0:
		if anim_player.get_current_animation() == cur_weapon.idle_anim:
			
			anim_player.stop()
			
			var p0 : float = randf_range(-20,20) * cur_weapon.pellet_spread #spread
			var p1 : float = randf_range(-15,-15) *  cur_weapon.pellet_spread 
			var p2 : float = randf_range(-5,5) *  cur_weapon.pellet_spread 
			var p3 : float = randf_range(-5,5) *  cur_weapon.pellet_spread 
			var p4 : float = randf_range(-15,15) *  cur_weapon.pellet_spread 
			var p5 : float = randf_range(-20,20) *  cur_weapon.pellet_spread 
			
			for angle in [p0, p1, p2, p3, p4, p5]: #Instantiating a new pellet for every angle
				var radians = deg_to_rad(angle)
				var b = bullet.instantiate()
				b.direction = aim_dir.rotated(radians)
				b.global_position = $Muzzle.global_position #setting pellet position at muzzle of shotgun
				#get_tree().get_root().add_child(b)
				owner.add_child(b)
				b.set("gun_man", self)
			
			anim_player.queue(cur_weapon.fire_anim)
			cur_weapon.loaded_ammo -= 1
			#print("Current wepaon's loaded ammo = " + str(cur_weapon.loaded_ammo))
			if cur_weapon.auto_fire != true:
				anim_player.queue(cur_weapon.cycle_anim)
			anim_player.queue(cur_weapon.idle_anim)
	else:
		print("Out of ammo! Reload!")
		anim_player.stop()
		anim_player.queue(cur_weapon.ooa_anim)
		anim_player.queue(cur_weapon.idle_anim)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == cur_weapon.deactivate_anim:
		Change_Weapon(next_weapon)
