extends Timer




func _on_timeout():
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/cletus_prologue.dialogue"), "Start")
