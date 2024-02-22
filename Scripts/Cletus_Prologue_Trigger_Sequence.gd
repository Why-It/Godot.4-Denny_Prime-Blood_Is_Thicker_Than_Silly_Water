extends Area2D

@export var dialogue_id : int = 0

@export var aimtut : Node
@export var walktut : Node

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.owner.is_in_group("Cleetus"):
		if dialogue_id == 0:
			DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Look_Around")
			aimtut.Activate()
		elif dialogue_id == 1:
			DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Follow_Me")
			walktut.Activate()
		elif dialogue_id == 2:
			area.owner.WalkToNode($"../../CletusNavPoints/03")
		elif dialogue_id == 3:
			area.owner.WalkToNode($"../../CletusNavPoints/04")
		elif  dialogue_id == 4:
			area.owner.Idle()
		elif dialogue_id == 5:
			area.owner.Idle()
