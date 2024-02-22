extends Node2D

@onready var labels = $Labels
@onready var w_col = $Labels/Label
@onready var a_col = $Labels/Label2
@onready var s_col = $Labels/Label3
@onready var d_col = $Labels/Label4

@export var player : Node

var points : int = 0

func _ready():
	labels.set("visible", false)

func Activate():
	labels.set("visible", true)
	player.tut_move = true

func _input(event):
	if player.tut_move == true:
		if event.is_action_pressed("Up"):
			if w_col.get("visible"):
				RemoveW()
		
		if event.is_action_pressed("Down"):
			if s_col.get("visible"):
				RemoveS()
		
		if event.is_action_pressed("Left"):
			if a_col.get("visible"):
				RemoveA()
		
		if event.is_action_pressed("Right"):
			if d_col.get("visible"):
				RemoveD()

func IncPoints():
	points += 1
	
	if points >= 4:
		DONE()

@export var cleetus : Node

func DONE():
	cleetus.WalkToNode($"../PausableScenes/CletusNavPoints/02")
	queue_free()

func RemoveW():
	w_col.set("visible", false)
	IncPoints()

func RemoveA():
	a_col.set("visible", false)
	IncPoints()

func RemoveS():
	s_col.set("visible", false)
	IncPoints()

func RemoveD():
	d_col.set("visible", false)
	IncPoints()
