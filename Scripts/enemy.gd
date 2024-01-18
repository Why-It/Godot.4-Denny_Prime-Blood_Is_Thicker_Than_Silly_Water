extends CharacterBody2D

@export var EnemyType : int = 0

var enemy_health : int = 3

func EnemyTakeDamage():
	enemy_health -= 1
	#print("hit taken")
	if enemy_health <= 0:
		EnemyDeath()
		
func EnemyDeath():
	queue_free()
