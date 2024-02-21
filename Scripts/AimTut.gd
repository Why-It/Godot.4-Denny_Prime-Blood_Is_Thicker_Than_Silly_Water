extends Node2D

@onready var label = $laberl

@onready var aim1 = $AimArea
@onready var aim2 = $AimArea2
@onready var aim3 = $AimArea3
@onready var aim4 = $AimArea4

var readytostart : bool = false
var done : bool = false

var points : int = 0

var fuc : String = "one"

@export var cleetus : Node

func _ready():
	aim1.set("visible", false)
	aim2.set("visible", false)
	aim3.set("visible", false)
	aim4.set("visible", false)
	label.set("visible", false)

var opened : bool = false

func _process(delta):
	if readytostart:
		if !opened:
			Activate()
	if points == 4:
		DONE()
		points = 0

func Activate():
#	self.set("visible", true)
	
	aim1.set("visible", true)
	aim2.set("visible", true)
	aim3.set("visible", true)
	aim4.set("visible", true)
	label.set("visible", true)
	
	opened = true

func DONE():
	label.set("visible", false)
	cleetus.WalkToNode($"../PausableScenes/CletusNavPoints/01")

func IncPoints():
	points += 1

func _on_aim_area_mouse_entered():
	aim1.set("visible", false)
	IncPoints()
func _on_aim_area_2_mouse_entered():
	aim2.set("visible", false)
	IncPoints()
func _on_aim_area_3_mouse_entered():
	aim3.set("visible", false)
	IncPoints()
func _on_aim_area_4_mouse_entered():
	aim4.set("visible", false)
	IncPoints()
