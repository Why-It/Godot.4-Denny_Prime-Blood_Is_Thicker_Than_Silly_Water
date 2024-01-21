extends Node

var cur_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func ChangeToScene(scene_name: String):
	get_tree().change_scene_to_file(scene_name)
	cur_scene = scene_name
