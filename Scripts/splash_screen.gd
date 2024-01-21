extends Control

@onready var anim_player = $AnimationPlayer
@onready var scene_loader = get_node("/root/SceneLoader")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.queue("godot_anim")
	#print(scene_loader)
	#print(str(scene_loader))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("Accept"):
		anim_player.speed_scale += 4


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "godot_anim":
		anim_player.play("dp_anim")
	
	if anim_name == "dp_anim":
		scene_loader.ChangeToScene("res://Scenes/main_menu.tscn")
