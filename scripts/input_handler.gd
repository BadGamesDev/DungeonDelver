extends Node

@onready var tile_map = $"../TileMap"
@onready var player

func _process(delta): #TEMPORARY SOLUTION
	while player == null:
		player = $"../character_spawner/player"

func _input(event):
	if event.is_action_pressed("right"):
		move(Vector2i.RIGHT)
	elif event.is_action_pressed("left"):
		move(Vector2i.LEFT)
	elif event.is_action_pressed("up"):
		move(Vector2i.UP)
	elif event.is_action_pressed("down"):
		move(Vector2i.DOWN)

func move(dir):
	var current_cell = tile_map.get_cell_at(player.data.cell.cell_position)
	var target = tile_map.get_cell_at(player.data.cell.cell_position + dir)
	if target.character == null:
		if target.walkable == true:
			if current_cell.tile == tile_map.tile["door_open"]:
				tile_map.set_cell(0, current_cell.cell_position, 0, tile_map.tile["door"])
				current_cell.tile = tile_map.tile["door"]
				
			if target.tile == tile_map.tile["entrance"]:
				player.data.cell = tile_map.get_cell_at(player.data.cell.cell_position + dir)
				player.position = tile_map.map_to_local(player.data.cell.cell_position)
				target.character = player
				current_cell.character = null
				
			if target.tile == tile_map.tile["exit"]:
				player.data.cell = tile_map.get_cell_at(player.data.cell.cell_position + dir)
				player.position = tile_map.map_to_local(player.data.cell.cell_position)
				target.character = player
				current_cell.character = null
				
			if target.tile == tile_map.tile["floor"]:
				player.data.cell = tile_map.get_cell_at(player.data.cell.cell_position + dir)
				player.position = tile_map.map_to_local(player.data.cell.cell_position)
				target.character = player
				current_cell.character = null
			
			elif target.tile == tile_map.tile["door"]:
				player.data.cell = tile_map.get_cell_at(player.data.cell.cell_position + dir)
				player.position = tile_map.map_to_local(player.data.cell.cell_position)
				tile_map.set_cell(0, target.cell_position, 0, tile_map.tile["door_open"])
				target.tile = tile_map.tile["door_open"]
				target.character = player
				current_cell.character = null
	else:
		player.functions.attack(target.character)
		print(target.character.data.health)
