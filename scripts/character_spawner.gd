extends Node

@onready var tile_map = $"../TileMap"

var ID = 0
var type = {
	"player": preload("res://prefabs/player.tscn"),
	"rat": preload("res://prefabs/mob_rat.tscn")
	}

func spawn_player(position):
	var new_spawn = type["player"].instantiate()
	new_spawn.position = tile_map.map_to_local(position)
	tile_map.get_cell_at(position).character = new_spawn
	add_child(new_spawn)
	
	var new_spawn_data = new_spawn.get_child(1)
	
	new_spawn_data.ID = ID
	new_spawn_data.character_name = "Can"
	new_spawn_data.health = 20
	new_spawn_data.attack = 4
	new_spawn_data.cell = tile_map.get_cell_at(position)
	
	ID += 1

func spawn_rat(position):
	var new_spawn = type["rat"].instantiate()
	new_spawn.position = tile_map.map_to_local(position)
	tile_map.get_cell_at(position).character = new_spawn
	add_child(new_spawn)
	
	var new_spawn_data = new_spawn.get_child(1)
	
	new_spawn_data.ID = ID
	new_spawn_data.character_name = "Rat"
	new_spawn_data.health = 8
	new_spawn_data.attack = 2
	new_spawn_data.cell = tile_map.get_cell_at(position)
	
	ID += 1

