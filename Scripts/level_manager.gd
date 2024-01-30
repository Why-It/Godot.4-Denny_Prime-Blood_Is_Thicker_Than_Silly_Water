extends Node

@onready var player = $PausableScenes/Player
@onready var camera = $PausableScenes/Player/Camera2D
@onready var gun_man = $PausableScenes/Player/gun_manager
@onready var gui = $GUI
@onready var bullet = $PausableScenes/Bullet

@onready var audio_man = get_node("/root/AudioManager")



@export var is_paused : bool = false
var isPlayerDead : bool = false

func _ready():
	player.set("gun_manager", gun_man)
	is_paused = false
	get_tree().paused = false
	
	if camera == null:
		print("camera is null")
	elif player == null:
		print("player is null")
	elif gui == null:
		print("gui is null")
	elif gun_man == null:
		print("gun_man is null")
	elif bullet == null:
		print("bullet is null")
	elif gun_man.bullet == null:
		print("the bullet in gun_man is null")

func _input(event):
	if event.is_action_pressed("Pause"):
		PAUSE()
		gui.TogglePauseUI()


func PAUSE():
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		AudioServer.set_bus_effect_enabled(1, 0, true)
	else:
		AudioServer.set_bus_effect_enabled(1, 0, false)

func _process(_delta):
	gui.set("cur_ammo_gui", gun_man.cur_ammo)
	gui.set("cur_reserve_gui", gun_man.cur_reserve)
	gui.UpdateAmmoDetails()

func PlayerHadDied():
	is_paused = true
	
