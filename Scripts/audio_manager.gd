extends Node


@onready var music_folder : Node = $Music
@onready var _music : Array[Node]

var cur_scene : String
var cur_song : Node

var master_volume : float = 0
var music_volume : float = 0
var sfx_volume : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in music_folder.get_children():
		_music.push_back(child)
		#print(_music)
	
	cur_song = _music[0]
	cur_song.set("playing", true)
	
	AudioServer.set_bus_volume_db(0, master_volume)
	AudioServer.set_bus_volume_db(1, music_volume)
	AudioServer.set_bus_volume_db(2, sfx_volume)

func StopSong():
	cur_song.set("playing", false)
func StartSong():
	#print(cur_scene)
	
	if cur_scene == "res://Scenes/main_menu.tscn":
		cur_song = _music[0]
	elif cur_scene == "res://Levels/1. Clyde's Place.tscn":
		cur_song = _music[1]
	
	
	cur_song.set("playing", true)


@export var _alert_sfx : Array[Node]
func PlayAlert():
	var which_alert = randf_range(0, _alert_sfx.size() - 1)
	
	_alert_sfx[which_alert].set("playing", true)

@export var _swing : Array[Node]
func PlaySwing():
	var which_swing = randf_range(0, _swing.size() - 1)
	
	_swing[which_swing].set("playing", true)

@export var _death : Array[Node]
func PlayDie():
	var which_die = randf_range(0, _death.size() - 1)
	
	_death[which_die].set("playing", true)

@export var _hurt : Array[Node]
func PlayHurt():
	var which_hurt = randf_range(0, _hurt.size() - 1)
	
	_hurt[which_hurt].set("playing", true)
