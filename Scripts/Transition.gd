extends Control

@onready var player : Node
@onready var scene_loader = get_node("/root/SceneLoader")
@onready var anim_player = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	if scene_loader.cur_scene != "splash_screen.tscn":
		anim_player.play("tran_enter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

var nextScene : String

func PlayExit(toNextScene : String):
	anim_player.play("tran_exit")
	nextScene = toNextScene

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "tran_exit":
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
		scene_loader.ChangeToScene(nextScene)

