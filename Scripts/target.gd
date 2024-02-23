extends Node2D


@export var id : String
@export var targets_array : Array[Node]

@onready var anim_player = $AnimationPlayer

var broken : bool = false

func _ready():
	for t in targets_array:
		if t.name == id:
			t.set("visible", true)
			t.set("monitoring", true)
			t.set("monitorable", true)
		else:
			t.set("visible", false)
			t.set("monitoring", false)
			t.set("monitorable", false)


func Break():
	if id == "Bottle":
		anim_player.play("bott_break")
	if id == "Box":
		anim_player.play("box_break")
	if id == "Clays":
		anim_player.play("clay_break")
	if id == "Cans":
		anim_player.play("can_break")
	if id == "Jugs":
		anim_player.play("jug_break")
	if id == "Dummy":
		anim_player.play("dum_break")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "bott_break":
		broken = true
		self.hide()
	if anim_name == "box_break":
		broken = true
		self.hide()
	if anim_name == "clay_break":
		broken = true
		self.hide()
	if anim_name == "jug_break":
		broken = true
		self.hide()
	if anim_name == "dum_break":
		broken = true
		self.hide()
	if anim_name == "can_break":
		broken = true
		self.hide()
