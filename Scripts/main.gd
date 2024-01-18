extends Node

@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var gun_man = $Player/gun_manager
@onready var gui = $GUI

func _ready():
	
	player.set("gun_manager", gun_man)
	
	if camera == null:
		print("camera is null")
	elif player == null:
		print("player is null")
	elif gui == null:
		print("gui is null")
	elif gun_man == null:
		print("gun_man is null")

func _process(_delta):
	gui.set("cur_ammo_gui", gun_man.cur_ammo)
	gui.set("cur_reserve_gui", gun_man.cur_reserve)
	gui.UpdateAmmoDetails()
