extends Node2D


@onready var anim_player = $AnimationPlayer
@onready var gun_pickup = $gun_pickup
@export var player : Node
@export var gun_man : Node
@export var gui : Node

@onready var wait_timer = $Timer

@onready var switch_lab = $swicth
@onready var reload_lab = $reload
@onready var shoot_lab = $shoot

@export var pump_res : Resource
@export var semi_res : Resource
@export var doub_res : Resource

@export var end_tut : Node

func _ready():
	anim_player.queue("pickup_idle")
	
	switch_lab.set("visible", false)
	reload_lab.set("visible", false)
	shoot_lab.set("visible", false)

func ActivateStage1():
	gun_pickup.queue_free()
	player.tut_acq_gun = true
	gun_man.Activate()
	wait_timer.start()
	switch_lab.set("visible", true)

func ActivateStage2():
	player.tut_reload = true
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Reload")
	gui.gameplay_UI.set("visible", true)
	reload_lab.set("visible", true)

func ActivateStage3():
	player.tut_shoot = true
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Shoot")
	shoot_lab.set("visible", true)

func ActivateStage4():
	end_tut.Start()

var has_switch_started : bool = false
var switch_points : int = 0
var is_pump_reloaded : bool = false
var is_semi_reloaded : bool = false
var is_doub_reloaded : bool = false
@export var targets : Array[Node]
var broken_points : int = 0
func _input(event):
	
	if !has_switch_started:
		if player.tut_switch == true:
			if event.is_action_pressed("Weapon_Next") or event.is_action_pressed("Weapon_Prev"):
				switch_points += 1
				
				if switch_points >= 3:
					has_switch_started = true
					switch_lab.set("visible", false)
					ActivateStage2()
	
	if reload_lab.get("visible"):
		
		if pump_res.loaded_ammo > 0:
			is_pump_reloaded = true
		
		if doub_res.loaded_ammo > 0:
			is_doub_reloaded = true
		
		if semi_res.loaded_ammo > 0:
			is_semi_reloaded = true
		
		if is_pump_reloaded:
			if is_semi_reloaded:
				if is_doub_reloaded:
					ActivateStage3()
					reload_lab.set("visible", false)
		
	if shoot_lab.get("visible"):
		for t in targets:
			if t.broken:
				broken_points += 1
		
		if broken_points < targets.size():
			broken_points = 0
		else:
			shoot_lab.set("visible", false)
			ActivateStage4()

func _on_gun_pickup_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.owner.is_in_group("Player_Prologue"):
		ActivateStage1()


func _on_timer_timeout():
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Switch_Guns")
	player.tut_switch = true
