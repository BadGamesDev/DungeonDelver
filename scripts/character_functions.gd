extends Node

@onready var main = $".."
@onready var data = $"../Data"
@onready var tile_map = $"../../../TileMap"

func move(input):
	var direction
	
	match input:
		"up_left":
			direction = Vector2i(-1, -1)
		"up":
			direction = Vector2i(0, -1)
		"up_right":
			direction = Vector2i(1, -1)
		"left":
			direction = Vector2i(-1, 0)
		"right":
			direction = Vector2i(1, 0)
		"down_left":
			direction = Vector2i(-1, 1)
		"down":
			direction = Vector2i(0, 1)
		"down_right":
			direction = Vector2i(1, 1)

	var current_cell = tile_map.get_cell_at(data.cell.cell_position)
	var target_cell = tile_map.get_cell_at(data.cell.cell_position + direction)
	
	if check_move(current_cell, target_cell):
		current_cell.character = null
		target_cell.character = main
		data.cell = target_cell
		main.position = tile_map.map_to_local(data.cell.cell_position)

func check_move(current_cell, target_cell): #Add movement speed to remove magic numbers
	if target_cell.character == null:
		if target_cell.walkable == true:
			if current_cell.tile == tile_map.tile["door_open"]: #autoclose doors
				tile_map.set_cell(0, current_cell.cell_position, 0, tile_map.tile["door"])
				current_cell.tile = tile_map.tile["door"]

			if target_cell.tile == tile_map.tile["door"]: #open door
				tile_map.set_cell(0, target_cell.cell_position, 0, tile_map.tile["door_open"])
				target_cell.tile = tile_map.tile["door_open"]
			return(true)
		
		else: #Not walkable
			return(false)
	
	else: #Not empty
		if target_cell.character.data.team != data.team:
			main.functions.attack(target_cell.character)
			return(false)

func attack(target):
	target.functions.take_damage(data.attack)
	print(target.data.health)

func take_damage(amount):
	data.health -= amount
	if data.health <= 0:
		die()

func gain_exp(amount):
	data.exp += amount
	if data.exp >= data.max_exp:
		level_up()

func level_up():
	data.max_health += 5
	
	data.exp -= data.max_exp
	data.max_exp += 5
	data.level += 1

func regen_health():
	data.health += 1

func die():
	$"../../player".functions.gain_exp(data.reward_exp)
	$"..".queue_free()
