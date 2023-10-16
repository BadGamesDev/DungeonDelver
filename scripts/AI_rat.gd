extends Node

@onready var player = $"../../../character_spawner/player"

@onready var data = $"../Data"
@onready var equipment = $"../Equipment"
@onready var functions = $"../Functions"

var diff_to_player

func AI_action():
		if -1 <= player.data.cell.cell_position.x - data.cell.cell_position.x and player.data.cell.cell_position.x - data.cell.cell_position.x <= 1 and -1 <= player.data.cell.cell_position.y - data.cell.cell_position.y and player.data.cell.cell_position.y - data.cell.cell_position.y <= 1:
			functions.attack(player, "head")
			print("attacked")
			data.time_action -= data.attack_speed
	
		elif -8 <= player.data.cell.cell_position.x - data.cell.cell_position.x and player.data.cell.cell_position.x - data.cell.cell_position.x <= 8 and -8 <= player.data.cell.cell_position.y - data.cell.cell_position.y and player.data.cell.cell_position.y - data.cell.cell_position.y <= 8:
			diff_to_player = player.position - $"../".position
			
			var allowed_moves =[
			"up_left",
			"up",
			"up_right",
			"left",
			"right",
			"down_left",
			"down",
			"down_right"]
			
			if diff_to_player.x > 0:
				allowed_moves.erase("up_left")
				allowed_moves.erase("left")
				allowed_moves.erase("down_left")
				
			if diff_to_player.x < 0:
				allowed_moves.erase("up_right")
				allowed_moves.erase("right")
				allowed_moves.erase("down_right")
			
			if diff_to_player.y > 0:
				allowed_moves.erase("up_left")
				allowed_moves.erase("up")
				allowed_moves.erase("up_right")
			
			if diff_to_player.y < 0:
				allowed_moves.erase("down_left")
				allowed_moves.erase("down")
				allowed_moves.erase("down_right")

			functions.move(allowed_moves[randi_range(0,allowed_moves.size() - 1)])
			data.time_action -= data.movement_speed
