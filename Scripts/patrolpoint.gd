extends Node2D

@export var pp_id : int = 0




func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.owner.is_in_group("Cleetus"):
		if pp_id == 0:
			area.owner.Idle()
		if pp_id == 1:
			area.owner.Idle()
		if pp_id == 2:
			area.owner.WalkToNode($"../03")
		if pp_id == 3:
			area.owner.WalkToNode($"../04")
		if pp_id == 4:
			area.owner.Idle()
