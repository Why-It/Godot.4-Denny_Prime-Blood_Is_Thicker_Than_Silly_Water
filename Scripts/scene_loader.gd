extends Node

var cur_scene : String

@onready var audio_man = get_node("/root/AudioManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_scene = str(get_tree().current_scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)	

func _input(event):
	if event.is_action_released("FullscreenToggle"):
		ToggleFullscreen()

var isFS : bool = false
var cur_window_status = 0
func ToggleFullscreen():
	cur_window_status = DisplayServer.window_get_mode()
	if cur_window_status == 0:
		isFS = false
	else:
		isFS = true
	isFS = !isFS
	if isFS:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func ChangeToScene(scene_name: String):
	#print(get_tree().current_scene.name)
	if get_tree().current_scene.name != "Splash Screen":
		audio_man.StopSong()
	
	audio_man.cur_scene = scene_name
	cur_scene = scene_name
	audio_man.cur_scene = cur_scene
	if get_tree().current_scene.name != "Splash Screen":
		audio_man.StartSong()
	get_tree().change_scene_to_file(scene_name)
