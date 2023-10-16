extends Node
#RENAME THIS TO ENTITY SPAWNER
@onready var tile_map = $"../TileMap"

var ID = 0
var type = {
	"player": preload("res://prefabs/player.tscn"),
	"rat": preload("res://prefabs/mob_rat.tscn"),
	"chest": preload("res://prefabs/chest_basic.tscn")
	}

func spawn_player(position):
	var new_spawn = type["player"].instantiate()
	new_spawn.position = tile_map.map_to_local(position)
	tile_map.get_cell_at(position).character = new_spawn
	add_child(new_spawn)
	
	var new_spawn_data = new_spawn.get_child(1)
	var new_spawn_equipment = new_spawn.get_child(6)
	
	new_spawn_data.ID = ID
	new_spawn_data.character_name = "Can"
	
	new_spawn_data.AI = false
	
	new_spawn_data.team = 1
	
	new_spawn_data.level = 1
	new_spawn_data.max_exp = 20
	new_spawn_data.exp = 0
	
	new_spawn_data.max_health = 20
	new_spawn_data.health = 20
	new_spawn_data.health_regen_speed = 1000
	
	new_spawn_data.attack = 4
	new_spawn_data.attack_speed = 100
	
	new_spawn_data.movement_speed = 1000
	
	new_spawn_data.time_health_regen = 0
	new_spawn_data.time_action = 0
	
	new_spawn_data.cell = tile_map.get_cell_at(position)
	
	new_spawn_equipment.equipment_slots = {
		"right hand": null, 
		"left hand": null, 
		"head": null, 
		"body": null, 
		"feet": null
		}
	
	ID += 1

func spawn_rat(position):
	var new_spawn = type["rat"].instantiate()
	new_spawn.position = tile_map.map_to_local(position)
	tile_map.get_cell_at(position).character = new_spawn
	add_child(new_spawn)
	
	var new_spawn_data = new_spawn.get_child(1)
	var new_spawn_equipment = new_spawn.get_child(6)
	
	new_spawn_data.ID = ID
	new_spawn_data.character_name = "Rat"
	
	new_spawn_data.AI = true
	
	new_spawn_data.team = 2
	
	new_spawn_data.level = 1
	new_spawn_data.max_exp = 20
	new_spawn_data.exp = 0
	new_spawn_data.reward_exp = 5
	
	new_spawn_data.max_health = 8
	new_spawn_data.health = 8
	new_spawn_data.health_regen_speed = 3000
	
	new_spawn_data.attack = 2
	new_spawn_data.attack_speed = 100
	
	new_spawn_data.movement_speed = 100
	
	new_spawn_data.time_health_regen = 0
	new_spawn_data.time_action = 0
	
	new_spawn_data.cell = tile_map.get_cell_at(position)
	
	new_spawn_equipment.equipment_slots = {
		"head": null, 
		"body": null, 
		"feet": null
		}
		
	ID += 1

func spawn_chest(position):
	var new_spawn = type["chest"].instantiate()
	new_spawn.position = tile_map.map_to_local(position)
	tile_map.get_cell_at(position).object = new_spawn
	add_child(new_spawn)
	
	var new_spawn_data = new_spawn.get_child(1)
	var new_spawn_inventory = new_spawn.get_child(3)
	
	new_spawn_data.ID = ID
	new_spawn_data.object_name = "Chest"
	
	new_spawn_data.cell = tile_map.get_cell_at(position)
	
	var a = ItemDatabase.items.keys()

	a = a[randi() % a.size()]
	new_spawn_inventory.add_item(ItemDatabase.items[a])
	for key in new_spawn_inventory.inventory.keys():
		print(key.item_name)
	ID += 1
