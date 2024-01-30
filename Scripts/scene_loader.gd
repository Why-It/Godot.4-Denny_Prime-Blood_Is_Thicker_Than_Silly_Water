extends Node

var cur_scene : String

@onready var audio_man = get_node("/root/AudioManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_scene = str(get_tree().current_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func ChangeToScene(scene_name: String):
	get_tree().change_scene_to_file(scene_name)
	audio_man.cur_scene = scene_name
	if cur_scene != "res://Scenes/splash_screen.tscn":
		pass
	audio_man.StartSong()
	cur_scene = scene_name
