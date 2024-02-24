extends Node2D


@export var prologue_enemy : Node
@export var player : Node
@export var cleetus : Node
@export var trans_man : Node

var is_enemy_dead : bool = false

var global : Node
var en_has_start : bool = false
var pro_chan_shoot : bool = false
var tut_ended : bool = false
var has_pro_en_died : bool = false

func _ready():
	global = get_node("/root/Globals")

func _process(_delta):
	
	if !is_enemy_dead:
		if prologue_enemy.cur_state == "Dead":
			
			is_enemy_dead = true
	
	if !en_has_start:
		if global.pro_enemy_started:
			EnemyWalksIn()
			
			global.pro_enemy_started = false
			en_has_start = true
	
	if !pro_chan_shoot:
		if global.pro_can_shoot:
			player.tut_shoot = true
			
			global.pro_can_shoot = false
			pro_chan_shoot = true
	
	if !tut_ended:
		if global.is_tut_ended:
			WeLeaving()
			
			global.is_tut_ended = false
			tut_ended = true
	
	if !has_pro_en_died:
		if prologue_enemy.get("isdead"):
			DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "EndTut")
			player.tut_shoot = false
			
			has_pro_en_died = true

func Start():
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Tutorial_End")
	player.WalkToNode($"../PausableScenes/PlayerNavPoint/00")
	player.tut_move = false
	player.tut_shoot = false

func EnemyWalksIn():
	cleetus.WalkToNode($"../PausableScenes/PlayerNavPoint/00")
	prologue_enemy.set("visible", true)
	prologue_enemy.WalkToNode($"../PausableScenes/CletusNavPoints/05")

func WeLeaving():
	trans_man.PlayExit("res://Levels/1. Clyde's Place.tscn")
