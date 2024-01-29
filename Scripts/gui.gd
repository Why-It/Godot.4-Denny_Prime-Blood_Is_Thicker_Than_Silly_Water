extends CanvasLayer

var cur_ammo_gui : int = 69
var cur_reserve_gui : int = 420

@onready var cur_ammo_display : Node = $GameplayUI/Rows/BottomRow/Right/Ammo/CurrentAmmo
@onready var cur_reserve_display : Node = $GameplayUI/Rows/BottomRow/Right/Ammo/ReserveAmmo

@onready var level_over_UI : Node = $LevelOverUI
@onready var level_over_text: Node = $LevelOverUI/Rows/MiddleRow/Middle/VBoxContainer/Label

@onready var pause_menu_UI : Node = $PauseMenuUI

@onready var lvl_tran : Node = $"../Transition"
@onready var lvl_man : Node = $".."

@onready var win_con : Node = $"../PausableScenes/WinCondition"

@export var win_text : String = "You Win! C:"
@export var lose_text : String = "You Lose! :C"

@onready var leave_UI : Node = $LeaveUI
@onready var player : Node = $"../PausableScenes/Player"


var pUI_on : bool = false
func TogglePauseUI():
	pUI_on = !pUI_on
	
	if pUI_on:
		pause_menu_UI.set("visible", true)
	else:
		pause_menu_UI.set("visible", false)

var eUI_on : bool = false
func ToggleEndUI():
	eUI_on = !eUI_on
	
	if eUI_on:
		get_tree().paused = true
		if win_con.did_player_win:
			level_over_text.set("text", win_text)
		else:
			level_over_text.set("text", lose_text)
		level_over_UI.set("visible", true)
	else:
		get_tree().paused = false
		level_over_UI.set("visible", true)

var leaveUI_on : bool = false
func ToggleLeaveUI():
	leaveUI_on = !leaveUI_on
	
	if leaveUI_on:
		leave_UI.set("visible", true)
		player.toggleArrow()
	else:
		leave_UI.set("visible", false)

# Called when the node enters the scene tree for the first time.
func _ready():
	if cur_ammo_display == null:
		print("cur_ammo_display is null")
	if cur_reserve_display == null:
		print("cur_ammo_display is null")
	if lvl_tran == null:
		print("lvl_tran is null")
	
	print(get_tree().current_scene.name)
	
	level_over_UI.set("visible", false)
	pause_menu_UI.set("visible", false)
	UpdateAmmoDetails()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func UpdateAmmoDetails():
	cur_ammo_display.set("text", str(cur_ammo_gui))
	cur_reserve_display.set("text", str(cur_reserve_gui))


func _on_main_menu_pressed():
	lvl_tran.PlayExit("res://Scenes/main_menu.tscn")


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_resume_pressed():
	lvl_man.PAUSE()


func _on_next_level_pressed():
	if get_tree().current_scene.name == "1_ Clyde's Place":
		lvl_tran.PlayExit("res://Levels/2. Massacre.tscn")
	elif get_tree().current_scene.name == "2_ Massacre":
		lvl_tran.PlayExit("res://Levels/3. We Spreadin'.tscn")
	elif get_tree().current_scene.name == "3_ We Spreadin'":
		lvl_tran.PlayExit("res://Scenes/credits.tscn")
