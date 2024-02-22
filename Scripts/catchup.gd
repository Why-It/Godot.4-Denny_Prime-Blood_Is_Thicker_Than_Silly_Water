extends Area2D

@export var cleetus : Node

@export var catchup_id : int = 0



func _on_area_shape_entered(_area_rid, area, area_shape_index, local_shape_index):
	
	print("something entered")
	print(area.owner.get_groups())
	
	if area.owner.is_in_group("Player_Prologue"):
		print("player entered")
		if catchup_id == 1:
			cleetus.WalkToNode($"../../PausableScenes/CletusNavPoints/05")
		elif catchup_id == 2:
			DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Pick_Up_Gun")
