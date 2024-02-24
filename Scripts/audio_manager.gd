extends Node


@onready var music_folder : Node = $Music
@onready var _music : Array[Node]

var cur_scene : String
var cur_song : Node

var master_volume : float = 0
var music_volume : float = 0
var sfx_volume : float = 0

var config = ConfigFile.new()
var err = config.load("user://audio.cfg")

func _init():
	if err != OK:
		return
	
	master_volume = config.get_value("master", "volume")
	music_volume = config.get_value("music", "volume")
	sfx_volume = config.get_value("sfx", "volume")

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in music_folder.get_children():
		_music.push_back(child)
		#print(_music)
	
	#print(get_tree().current_scene.name)
	cur_song = _music[0]
	cur_song.set("playing", true)
	
	AudioServer.set_bus_volume_db(0, master_volume)
	AudioServer.set_bus_volume_db(1, music_volume)
	AudioServer.set_bus_volume_db(2, sfx_volume)

func StopSong():
	cur_song.set("playing", false)
func StartSong():
	#print(cur_scene)
	
	AudioServer.set_bus_effect_enabled(1,0,false)
	
	
	if cur_scene == "res://Scenes/main_menu.tscn":
		cur_song = _music[0]
	elif cur_scene == "Splash Screen":
		cur_song = _music[0]
	elif cur_scene == "res://Levels/1. Clyde's Place.tscn":
		cur_song = _music[1]
	elif cur_scene == "res://Levels/2. Massacre.tscn":
		cur_song = _music[2]
	elif cur_scene == "res://Levels/3. We Spreadin'.tscn":
		cur_song = _music[3]
	elif cur_scene == "res://Levels/0. Prologue.tscn":
		cur_song = _music[4]
	else:
		cur_song = _music[5]
	
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

@export var _pump_reload : Array[Node]
func PlayPumpReload():
	var which_re = randf_range(0, _pump_reload.size() - 1)
	
	_pump_reload[which_re].set("playing", true)

func UpdateMasterVol(value : float):
	master_volume = value
	SaveAudioSettings()

func UpdateMusicVol(value : float):
	music_volume = value
	SaveAudioSettings()

func UpdateSfxVol(value : float):
	sfx_volume = value
	SaveAudioSettings()


func SaveAudioSettings():
	config.set_value("master", "volume", master_volume)
	config.set_value("music", "volume", music_volume)
	config.set_value("sfx", "volume", sfx_volume)
	
	config.save("user://audio.cfg")
