extends Node2D

@export var pp_id : int = 0




func _on_area_2d_area_shape_entered(_area_rid, area, area_shape_index, local_shape_index):
	if area.owner.is_in_group("Cleetus"):
		if pp_id == 0:
			area.owner.Idle()
			print("hit pp 0")
		elif  pp_id == 1:
			area.owner.Idle()
			print("hit pp 1")
		elif  pp_id == 2:
			area.owner.WalkToNode($"../03")
			print("hit pp 2")
		elif  pp_id == 3:
			area.owner.WalkToNode($"../04")
		elif  pp_id == 4:
			area.owner.Idle()
