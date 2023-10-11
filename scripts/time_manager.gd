extends Node

var time = 0

signal time_passed()

func _process(delta):
	while time > 0:
		emit_signal("time_passed")
		time -= 1
