extends CanvasLayer

var cur_ammo_gui : int = 69
var cur_reserve_gui : String = "∞"

@onready var gameplay_UI : Node = $GameplayUI
@onready var cur_ammo_display : Node = $GameplayUI/Rows/BottomRow/Right/Ammo/CurrentAmmo
@onready var cur_reserve_display : Node = $GameplayUI/Rows/BottomRow/Right/Ammo/ReserveAmmo

@onready var level_over_UI : Node = $LevelOverUI
@onready var level_over_text: Node = $LevelOverUI/Rows/MiddleRow/Middle/VBoxContainer/Label

@onready var pause_menu_UI : Node = $PauseMenuUI

@onready var lvl_tran : Node = $"../Transition"
@onready var lvl_man : Node = $".."

@onready var win_con : Node 

@export var win_text : String = "You Win! C:"
@export var lose_text : String = "You Lose! :C"

@onready var leave_UI : Node = $LeaveUI
@onready var player : Node

@onready var death_UI : Node = $DeathUI

@onready var options_UI : Node = $OptionsUI
@onready var masterslider : Node = $OptionsUI/Rows/MiddleRow/Middle/VBoxContainer/MasterSlider
@onready var musicslider : Node = $OptionsUI/Rows/MiddleRow/Middle/VBoxContainer/MusicSlider
@onready var sfxsldier : Node = $OptionsUI/Rows/MiddleRow/Middle/VBoxContainer/SFXSlider


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
	
	if get_tree().current_scene.name != "MainMenu":
		gameplay_UI.set("visible", true)
		win_con = $"../PausableScenes/WinCondition"
		player = $"../PausableScenes/Player"
	else:
		gameplay_UI.set("visible", false)
	
	masterslider.set("value", audio_man.master_volume)
	musicslider.set("value", audio_man.music_volume)
	sfxsldier.set("value", audio_man.sfx_volume)
	
	#print(get_tree().current_scene.name)
	
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

func ToggleDeathUI():
	death_UI.set("visible", true)
	get_tree().paused = true


func _on_next_level_pressed():
	if get_tree().current_scene.name == "1_ Clyde's Place":
		lvl_tran.PlayExit("res://Levels/2. Massacre.tscn")
	elif get_tree().current_scene.name == "2_ Massacre":
		lvl_tran.PlayExit("res://Levels/3. We Spreadin'.tscn")
	elif get_tree().current_scene.name == "3_ We Spreadin'":
		lvl_tran.PlayExit("res://Scenes/credits.tscn")

func ToggleOptionsUI():
	options_UI.set("visible", !options_UI.get("visible"))

@onready var audio_man = get_node("/root/AudioManager")

func _on_master_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(0, masterslider.get("value"))
	audio_man.UpdateMasterVol(masterslider.get("value"))


func _on_music_slider_value_changed(_value):
	AudioServer.set_bus_volume_db(1, musicslider.get("value"))
	audio_man.UpdateMusicVol(musicslider.get("value"))


func _on_sfx_slider_drag_ended(_value_changed):
	AudioServer.set_bus_volume_db(2, sfxsldier.get("value"))
	audio_man.UpdateSfxVol(sfxsldier.get("value"))
	audio_man.PlayAlert()


func _on_return_pressed():
	ToggleOptionsUI()


func _on_options_pressed():
	ToggleOptionsUI()


func _on_pause_options_pressed():
	ToggleOptionsUI()


func _on_fullscreen_pressed():
	var isFullScreen : int
	isFullScreen = DisplayServer.window_get_mode()
	
	if isFullScreen != 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
