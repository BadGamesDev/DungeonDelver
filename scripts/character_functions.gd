extends Node

@onready var data = $"../Data"

func move(position):
	$"..".position = position

func attack(target):
	target.functions.take_damage(data.attack)

func take_damage(damage):
	data.health -= damage
	if data.health <= 0:
		die()

func die():
	$"..".queue_free()
