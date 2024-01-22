extends Control

@onready var levelTransition = $Transition
@onready var levelSelect_Menu = $BoxContainer/Center/VBoxContainer/LevelSelect.get_popup()

func _ready():
	levelSelect_Menu.connect("id_pressed", ItemPressed)

func ItemPressed(id):
	#print(levelSelect_Menu.get_item_text(id))
	
	var lvl = str("res://Levels/" + levelSelect_Menu.get_item_text(id) + ".tscn")
	levelTransition.PlayExit(lvl)

func _on_quit_pressed():
	get_tree().quit()
