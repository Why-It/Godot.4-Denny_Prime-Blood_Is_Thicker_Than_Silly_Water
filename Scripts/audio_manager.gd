extends Node2D

@onready var music_folder : Node = $Music
@onready var _music : Array[Node]

var cur_song : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in music_folder.get_children():
		_music.push_back(child)
		print(_music)
	
	cur_song = _music[0]
	print("cur_song = " + str(cur_song))
	
	cur_song.set("playing", true)

func StopSong():
	cur_song.set("playing", false)

func StartSong():
	cur_song.set("playing", true)
