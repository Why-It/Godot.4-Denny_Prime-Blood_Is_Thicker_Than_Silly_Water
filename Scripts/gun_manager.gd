extends Node2D

@export var anim_player : AnimationPlayer
@onready var particle_marker : Node = $particle
@onready var particle_emmiter = preload("res://Scenes/shot_particles.tscn")

#Shotgun Shooty Stuff
@onready var bullet = preload("res://Scenes/bullet.tscn")
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

@onready var audio_man = get_node("/root/AudioManager")

@onready var playernode : Node = $".."

func _ready():
	Initilize(starting_arsenal) #Enter the state machine
	for weapon in _weapon_resources:
		weapon.loaded_ammo = weapon.max_loaded_ammo
		weapon.pellet_spread = weapon.spread_min

	
func _input(event):
	if !playernode.is_player_dead:
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
			if continuous_reload == true:
				continuous_reload = false
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


func _physics_process(_delta):
	aim_dir = global_position.direction_to(get_global_mouse_position())
	
	for shotgun in _weapon_resources:
		if shotgun.pellet_spread > 0.5:
			shotgun.pellet_spread -= 0.1 * shotgun.spread_recover_speed * _delta
			
			if shotgun.pellet_spread < shotgun.spread_min:
				shotgun.pellet_spread = 0.5
			
			#print(shotgun.weapon_name + " spread is "+ str(shotgun.pellet_spread))
	
	if continuous_reload == true:
		Reload()
	
	UpdateAmmo()
	Spread_Shower_Update()
	
	if playernode.is_player_dead:
		self.set("visible", false)

func UpdateAmmo():
	cur_ammo = cur_weapon.loaded_ammo
	cur_reserve = cur_weapon.reserve_ammo

func enter(): #Call when entering the next weapon
	anim_player.queue(cur_weapon.activate_anim)
	anim_player.queue(cur_weapon.idle_anim)
	
	cur_ammo = cur_weapon.loaded_ammo
	cur_reserve = cur_weapon.reserve_ammo


func exit(_next_weapon : String): #Call before changing weapons
	if _next_weapon != cur_weapon.weapon_name:
		if anim_player.get_current_animation() != cur_weapon.deactivate_anim:
			anim_player.play(cur_weapon.deactivate_anim)
			next_weapon = _next_weapon
	
func Change_Weapon(weapon_name : String):
	cur_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()

func Increase_Spread_Value():
	if cur_weapon.pellet_spread < cur_weapon.spread_max:
		cur_weapon.pellet_spread += cur_weapon.spread_increase

func Spread_Shower_Update():
	spread_shower.set("value", cur_weapon.pellet_spread * 100.5)

var continuous_reload : bool = false

func Reload():
	if anim_player.get_current_animation() == cur_weapon.idle_anim:
		if cur_weapon.reserve_ammo > 0:
			if cur_weapon.loaded_ammo < cur_weapon.max_loaded_ammo:
				
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
					if cur_weapon.weapon_name == "Pump":
						audio_man.PlayPumpReload()
					elif cur_weapon.weapon_name == "Semi":
						audio_man.PlayPumpReload()
					cur_weapon.loaded_ammo += 1
				
				anim_player.queue(cur_weapon.idle_anim)
				
				if cur_weapon.loaded_ammo >= cur_weapon.max_loaded_ammo:
					continuous_reload = false
				else:
					continuous_reload = true
				#print("Current Ammo in Shotgun: " + str(cur_weapon.loaded_ammo))

func Shoot():
	if cur_weapon.loaded_ammo > 0:
		if anim_player.get_current_animation() == cur_weapon.idle_anim:
			
			#print(spread_shower.get("value"))
			
			#halting the animation of whatever the player is doing in order to 
			anim_player.stop()
			
			#determining the angle of each shot from the blast
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
				owner.add_child(b)
				b.set("gun_man", self)
			
			#Instatiating a particle effect to the shot
			var pe = particle_emmiter.instantiate()
			pe.global_position = particle_marker.global_position
			pe.look_at(get_global_mouse_position())
			pe.rotation_degrees += 90
			pe.set("one_shot", true)
			pe.set("emitting", true)
			owner.add_child(pe)
			
			anim_player.queue(cur_weapon.fire_anim)
			cur_weapon.loaded_ammo -= 1
			
			#Making the rat of fire for whatever is classified as "automatic" faster by skipping the cycle aniamtion. (this is will rtypically be included in the "fire" aniamtion)
			if cur_weapon.auto_fire != true:
				anim_player.queue(cur_weapon.cycle_anim)
			anim_player.queue(cur_weapon.idle_anim)
	else:
		#print("Out of ammo! Reload!")
		anim_player.stop()
		anim_player.queue(cur_weapon.ooa_anim)
		anim_player.queue(cur_weapon.idle_anim)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == cur_weapon.deactivate_anim:
		Change_Weapon(next_weapon)
