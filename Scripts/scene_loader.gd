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
	if get_tree().current_scene.name != "Splash Screen":
		audio_man.StartSong()
	#print(get_tree().current_scene.name)
	get_tree().change_scene_to_file(scene_name)
	audio_man.cur_scene = scene_name
	cur_scene = scene_name
