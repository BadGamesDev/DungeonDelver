extends Node

@onready var player_health = $main_ui/player_health
@onready var player_exp = $main_ui/player_exp
@onready var player_level = $main_ui/player_level

@onready var player = $"../character_spawner/player"

func _process(delta):
	update_player_health_ui()
	update_player_exp_ui()

func update_player_health_ui():
	player_health.text = "Health: " + str(player.data.health) + " / " + str(player.data.max_health)

func update_player_exp_ui():
	player_exp.text = "Exp: " + str(player.data.exp) + " / " + str(player.data.max_exp)
