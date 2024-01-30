extends Control

@onready var levelTransition = $Transition
@onready var levelSelect_Menu = $MainMenuUI/Center/VBoxContainer/LevelSelect.get_popup()

func _ready():
	levelSelect_Menu.connect("id_pressed", ItemPressed)

func ItemPressed(id):
	#print(levelSelect_Menu.get_item_text(id))
	
	var lvl = str("res://Levels/" + levelSelect_Menu.get_item_text(id) + ".tscn")
	levelTransition.PlayExit(lvl)

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	levelTransition.PlayExit("res://Levels/1. Clyde's Place.tscn")


func _on_credits_pressed():
	levelTransition.PlayExit("res://Scenes/credits.tscn")
