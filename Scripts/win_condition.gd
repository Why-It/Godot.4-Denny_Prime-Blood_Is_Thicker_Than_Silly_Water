extends Node
@export var enemy_array : Array[Node]

var did_player_win : bool = false

var target_amount : int
var amount_dead : int
var tar_am_ach : bool = false

@onready var gui : Node = $"../../GUI"

func _ready():
	target_amount = enemy_array.size()

func UpdateEnemyDeathCount():
	
	amount_dead += 1
	
	if amount_dead >= target_amount:
		tar_am_ach = true
		gui.ToggleLeaveUI()
		#did_player_win = true
		#gui.ToggleEndUI()
		#print("Player Win")

"""
	if area:
		if tar_am_ach:
			did_player_win = true
			gui.ToggleEnd()
			print("PLayer W")
"""

func Win():
	did_player_win = true
	gui.ToggleEndUI()
	print("PLayer W")


func _on_area_2d_2_area_entered(area):
	if area:
		if tar_am_ach:
			Win()
