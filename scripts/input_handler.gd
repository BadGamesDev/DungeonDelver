extends Node2D

@onready var tile_map = $"../TileMap"
@onready var time_manager = $"../time_manager" #not sure if this is the best way of handling time, maybe I don't need the middle man
@onready var player

func _process(delta): #TEMPORARY SOLUTION
	while player == null:
		player = $"../character_spawner/player"

func _input(event):
	if Input.is_action_pressed("interact"):
		if event.is_action_pressed("up_left"):
			player.functions.interact("up_left")
			spend_time(100)
		elif event.is_action_pressed("up"):
			player.functions.interact("up")
			spend_time(100)
		elif event.is_action_pressed("up_right"):
			player.functions.interact("up_right")
			spend_time(100)
		elif event.is_action_pressed("left"):
			player.functions.interact("left")
			spend_time(100)
		elif event.is_action_pressed("right"):
			player.functions.interact("right")
			spend_time(100)
		elif event.is_action_pressed("down_left"):
			player.functions.interact("down_left")
			spend_time(100)
		elif event.is_action_pressed("down"):
			player.functions.interact("down")
			spend_time(100)
		elif event.is_action_pressed("down_right"):
			player.functions.interact("down_right")
			spend_time(100)
		elif event.is_action_pressed("middle"):
			spend_time(100)
	else:
		if event.is_action_pressed("up_left"):
			player.functions.move("up_left")
			spend_time(100)
		elif event.is_action_pressed("up"):
			player.functions.move("up")
			spend_time(100)
		elif event.is_action_pressed("up_right"):
			player.functions.move("up_right")
			spend_time(100)
		elif event.is_action_pressed("left"):
			player.functions.move("left")
			spend_time(100)
		elif event.is_action_pressed("right"):
			player.functions.move("right")
			spend_time(100)
		elif event.is_action_pressed("down_left"):
			player.functions.move("down_left")
			spend_time(100)
		elif event.is_action_pressed("down"):
			player.functions.move("down")
			spend_time(100)
		elif event.is_action_pressed("down_right"):
			player.functions.move("down_right")
			spend_time(100)
		elif event.is_action_pressed("middle"):
			spend_time(100)

	if event.is_action_pressed("mouse_button_left"):
		print("Mouse Click/Unclick at: ", tile_map.local_to_map(get_global_mouse_position()))
	elif event.is_action_pressed("mouse_button_right"):
		print("Mouse Click/Unclick at: ", tile_map.local_to_map(get_global_mouse_position()))

func spend_time(time): #not using the time manger for now
	time_manager.time += time

