extends Node2D

signal enemy_start
signal pro_can_shoot_enemy
signal end_tut
var pro_enemy_started : bool = false
var pro_can_shoot : bool = false
var is_tut_ended : bool = false

func _ready():
	enemy_start.connect(TogglePrologueEnemy)
	pro_can_shoot_enemy.connect(ToggleProShoot)
	end_tut.connect(ToggleEndTut)

func ToggleEndTut(e):
	is_tut_ended = e
func ToggleProShoot(w):
	pro_can_shoot = w
func TogglePrologueEnemy(v):
	pro_enemy_started = v
