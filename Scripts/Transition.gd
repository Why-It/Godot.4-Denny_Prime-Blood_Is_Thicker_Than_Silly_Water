extends Control

@onready var player : Node
@onready var scene_loader = get_node("/root/SceneLoader")
@onready var audio_man = get_node("/root/AudioManager")
@onready var anim_player = $AnimationPlayer




# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene.name == "0_ Prologue":
		woke = false
		anim_player.play("tran_idle")
	else:
		anim_player.play("tran_enter")

var woke : bool = false
func _input(_event):
	if Input.is_action_pressed("Accept"):
		
		if get_tree().current_scene.name == "0_ Prologue":
			if !woke:
				anim_player.stop()
				anim_player.queue("tran_enter")
				woke = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

var nextScene : String

func PlayExit(toNextScene : String):
	if get_tree().current_scene.name == "0_ Prologue":
		anim_player.set("speed_scale", 0.5)
		anim_player.play("tran_exit")
	else:
		anim_player.play("tran_exit")
	nextScene = toNextScene

var cleetus = null

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "tran_exit":
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
		
		scene_loader.ChangeToScene(nextScene)
	
	if anim_name == "tran_enter":
		if get_tree().current_scene.name == "0_ Prologue":
			cleetus = $"../PausableScenes/Cletus"
			cleetus.WalkToNode($"../PausableScenes/CletusNavPoints/00")
