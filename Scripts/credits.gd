extends Control

@onready var levelTransition = $Transition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_return_to_main_pressed():
	levelTransition.PlayExit("res://Scenes/main_menu.tscn")
