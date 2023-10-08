extends TileMap

var tile = {
	"floor": Vector2i(0, 0),
	"wall": Vector2i(1, 0),
	"door": Vector2i(2, 0),
	"entrance": Vector2i(3, 0),
	"exit": Vector2i(4, 0),
	"debug_side_path": Vector2i(5, 7),
	"debug_path": Vector2i(6, 7),
	"debug_fill": Vector2i(7, 7)}

class Room:
	var ID : int
	var type : int
	var area : Rect2
	var connected : bool
	var neighbors : Array

class Cell:
	var ID : int
	var cell_position : Vector2i
	var cell_room : Room
	var npc : CharacterBody2D
	var tile : Vector2i

var level_area = Rect2(Vector2i(1, 1), Vector2i(32, 32))
var max_room_size = 8
var partitioned_areas = []
var rooms = []
var cell_dictionary = {}
var connected_rooms = []
var entrance_pos = Vector2i(0, 0)

func addCell(cell):
	cell_dictionary[cell.cell_position] = cell

func get_cell_at(cell_position):
	if cell_position in cell_dictionary:
		return cell_dictionary[cell_position]

func _ready():
	generate_bsp(level_area)
	get_cells()
	get_rooms()
	place_floors()
	place_walls()
	place_entrances()
	set_room_types()
	fill_rooms()
	update_cells()

func generate_bsp(area):
	if area.size.x > max_room_size and area.size.y > max_room_size:
		var random_direction = randi_range(0, 2)
		split(random_direction, area)
	
	elif area.size.x > max_room_size:
		split(0, area)
	
	elif area.size.y > max_room_size:
		split(1, area)
	
func split(direction, area):
	if direction == 1:
		# Split horizontally
		var split_point = randi_range(4, area.size.y - 3)
		var top_rect = Rect2(area.position, Vector2(area.size.x, split_point))
		var bottom_rect = Rect2(area.position + Vector2(0, split_point + 1), Vector2(area.size.x, area.size.y - (split_point + 1)))
		
		partitioned_areas.append(top_rect)
		partitioned_areas.append(bottom_rect)

		generate_bsp(top_rect)
		generate_bsp(bottom_rect)

	else:
		# Split vertically
		var split_point = randi_range(4, area.size.x - 3)
		var left_rect = Rect2(area.position, Vector2(split_point, area.size.y))
		var right_rect = Rect2(area.position + Vector2(split_point + 1, 0), Vector2(area.size.x - (split_point + 1), area.size.y))

		partitioned_areas.append(left_rect)
		partitioned_areas.append(right_rect)

		generate_bsp(left_rect)
		generate_bsp(right_rect)

func get_rooms():
	var ID_number = 0
	
	for area in partitioned_areas:
		if area.size.x <= max_room_size && area.size.y <= max_room_size:
			var new_room = Room.new()
			new_room.ID = ID_number
			new_room.type = 0
			new_room.area = Rect2(area.position, area.size)
			new_room.connected = false
			rooms.append(new_room)
			ID_number += 1

func get_cells():
	var ID_number = 0
	
	for x in range(int(level_area.position.x - 1), int(level_area.end.x + 1)):
		for y in range(int(level_area.position.y - 1), int(level_area.end.y + 1)):
			var new_cell = Cell.new()
				
			new_cell.ID = ID_number
			new_cell.cell_position = Vector2i(x, y)
			new_cell.cell_room = null
			new_cell.tile = get_cell_atlas_coords(0, Vector2i(x, y), 0)
			addCell(new_cell)
			ID_number += 1

func update_cells(): #EXTREMELY BAD FUNCTION. REMOVE IT IN THE FUTURE
	for x in range(int(level_area.position.x - 1), int(level_area.end.x + 1)):
		for y in range(int(level_area.position.y - 1), int(level_area.end.y + 1)):
			var cell = get_cell_at(Vector2i(x,y))
			cell.tile = get_cell_atlas_coords(0, Vector2i(x, y), 0)

func place_floors():
	for room in rooms:
		var x_start = int(room.area.position.x)
		var y_start = int(room.area.position.y)
		var x_end = int(room.area.position.x + room.area.size.x)
		var y_end = int(room.area.position.y + room.area.size.y)
		
		for x in range(x_start, x_end):
			for y in range(y_start, y_end):
				set_cell(0, Vector2i(x, y), 0, tile["floor"])
				get_cell_at(Vector2i(x, y)).cell_room = room

func place_walls():
	for x in range(int(level_area.position.x - 1), int(level_area.end.x + 1)):
		for y in range(int(level_area.position.y - 1), int(level_area.end.y + 1)):
			if get_cell_tile_data(0, Vector2i(x, y), 0) == null:
				set_cell(0, Vector2i(x, y), 0, tile["wall"])

func place_entrances():
	var minimum_distance = 20
	var eligible_rooms = []
	for room_cantidate in rooms:
		if room_cantidate.area.size.x >= 3 and room_cantidate.area.size.y >= 3:
			eligible_rooms.append(room_cantidate)

	if eligible_rooms.size() < 2:
		print("ERROR: Not enough eligible rooms.")
		return

	var random_eligible_room_index = randi() % eligible_rooms.size()
	var random_eligible_room = eligible_rooms[random_eligible_room_index]

	var random_eligible_exit_index = (random_eligible_room_index + randi() % (eligible_rooms.size() - 1) + 1) % eligible_rooms.size()
	var random_eligible_exit_room = eligible_rooms[random_eligible_exit_index]
	
	while random_eligible_room.area.position.distance_to(random_eligible_exit_room.area.position) < minimum_distance:
		random_eligible_exit_index = (random_eligible_room_index + randi() % (eligible_rooms.size() - 1) + 1) % eligible_rooms.size()
		random_eligible_exit_room = eligible_rooms[random_eligible_exit_index]

	var entrance_x = randf_range(int(random_eligible_room.area.position.x) + 1, int(random_eligible_room.area.position.x + random_eligible_room.area.size.x) - 1) #randi_range can create exit and entrance outside of room for some reason
	var entrance_y = randf_range(int(random_eligible_room.area.position.y) + 1, int(random_eligible_room.area.position.y + random_eligible_room.area.size.y) - 1)
	entrance_pos = Vector2i(entrance_x, entrance_y)
	set_cell(0, entrance_pos, 0, tile["entrance"])
	

	var exit_x = randf_range(int(random_eligible_exit_room.area.position.x) + 1, int(random_eligible_exit_room.area.position.x + random_eligible_exit_room.area.size.x) - 1)
	var exit_y = randf_range(int(random_eligible_exit_room.area.position.y) + 1, int(random_eligible_exit_room.area.position.y + random_eligible_exit_room.area.size.y) - 1)
	set_cell(0, Vector2i(exit_x, exit_y), 0, tile["exit"])
	
	random_eligible_room.type = 1
	random_eligible_room.connected = true
	random_eligible_exit_room.type = 2
	
	connected_rooms.append(random_eligible_room)
	
	print("Entrances placed.")
	draw_path(Vector2i(entrance_x, entrance_y), Vector2i(exit_x, exit_y))

func draw_path(start_cell, end_cell):
	var i = 0
	var cur_cell = start_cell
	var try = 0
	
	while cur_cell != end_cell and i < 10000:
		i += 1
		var roll = randi_range(0,1)
		var diff = end_cell - cur_cell
		
		if diff.x > 0:
			diff.x = 1
		if diff.x < 0:
			diff.x = -1
		if diff.y > 0:
			diff.y = 1
		if diff.y < 0:
			diff.y = -1

		if roll == 0: #HORIZONTAL
			if get_cell_atlas_coords(0, cur_cell + Vector2i(diff.x, 0), 0) == tile["floor"]:
				cur_cell += Vector2i(diff.x, 0)
				set_cell(0, cur_cell, 0, tile["debug_path"])
			
			elif get_cell_atlas_coords(0, cur_cell + Vector2i(diff.x, 0), 0) == tile["exit"]:
				cur_cell += Vector2i(diff.x, 0)
			
			elif get_cell_atlas_coords(0, cur_cell + Vector2i(diff.x, 0), 0) == tile["wall"]:
				if get_cell_atlas_coords(0, cur_cell + Vector2i(diff.x * 2, 0), 0) == tile["floor"] and get_cell_at(cur_cell + Vector2i(diff.x * 2, 0)).cell_room.connected == false:
					get_cell_at(cur_cell + Vector2i(diff.x * 2, 0)).cell_room.connected = true
					cur_cell += Vector2i(diff.x, 0)
					set_cell(0, cur_cell, 0, tile["door"])
					cur_cell += Vector2i(diff.x, 0)
					set_cell(0, cur_cell, 0, tile["debug_path"])

				elif try > 100:
					try = 0
					var y = 0
					if get_cell_atlas_coords(0, cur_cell + Vector2i(0, 1), 0) == tile["floor"]:
						y = 1
					elif get_cell_atlas_coords(0, cur_cell + Vector2i(0, -1), 0) == tile["floor"]:
						y = -1
					while get_cell_atlas_coords(0, cur_cell + Vector2i(diff.x * 2, 0), 0) != tile["floor"]:
						print("stuck")
						cur_cell += Vector2i(0, y)
						set_cell(0, cur_cell, 0, tile["debug_path"])
				
				else:
					print("impassable" + str(roll) + str(i) + str(cur_cell))
					try += 1
		
		if roll == 1: #VERTICAL
			if get_cell_atlas_coords(0, cur_cell + Vector2i(0, diff.y), 0) == tile["floor"]:
				cur_cell += Vector2i(0, diff.y)
				set_cell(0, cur_cell, 0, tile["debug_path"])
			
			elif get_cell_atlas_coords(0, cur_cell + Vector2i(0, diff.y), 0) == tile["exit"]:
				cur_cell += Vector2i(0, diff.y)
			
			elif get_cell_atlas_coords(0, cur_cell + Vector2i(0, diff.y), 0) == tile["wall"]:
				if get_cell_atlas_coords(0, cur_cell + Vector2i(0, diff.y * 2), 0) == tile["floor"] and get_cell_at(cur_cell + Vector2i(0, diff.y * 2)).cell_room.connected == false:
					get_cell_at(cur_cell + Vector2i(0, diff.y * 2)).cell_room.connected = true
					cur_cell += Vector2i(0, diff.y)
					set_cell(0, cur_cell, 0, tile["door"])
					cur_cell += Vector2i(0, diff.y)
					set_cell(0, cur_cell, 0, tile["debug_path"])

				elif try > 100:
					try = 0
					var x = 0
					if get_cell_atlas_coords(0, cur_cell + Vector2i(1, 0), 0) == tile["floor"]:
						x = 1
					elif get_cell_atlas_coords(0, cur_cell + Vector2i(-1, 0), 0) == tile["floor"]:
						x = -1
					while get_cell_atlas_coords(0, cur_cell + Vector2i(0, diff.y * 2), 0) != tile["floor"]:
						print("stuck")
						cur_cell += Vector2i(x, 0)
						set_cell(0, cur_cell, 0, tile["debug_path"])

				else:
					print("impassable" + str(roll) + str(i) + str(cur_cell))
					try += 1

	print("Path found.")

func set_room_types():
	for room in rooms:
		if room.type != 1 and room.type != 2:
			if room.connected == false:
				room.type = 0 #EMPTY ROOM
			elif room.area.size.x < 3 or room.area.size.y < 3:
				room.type = 3 #CORRIDOOR ROOM
			else:
				room.type = 4 #NORMAL ROOM

func fill_rooms():
	for room in rooms:
		if room.connected == false:
			var x_start = int(room.area.position.x)
			var y_start = int(room.area.position.y)
			var x_end = int(room.area.position.x + room.area.size.x)
			var y_end = int(room.area.position.y + room.area.size.y)

			for x in range(x_start, x_end):
				for y in range(y_start, y_end):
					if get_cell_atlas_coords(0, Vector2i(x, y), 0) != tile["debug_path"]:
						set_cell(0, Vector2i(x, y), 0, tile["wall"])

		else:
			var x_start = int(room.area.position.x)
			var y_start = int(room.area.position.y)
			var x_end = int(room.area.position.x + room.area.size.x)
			var y_end = int(room.area.position.y + room.area.size.y)

			for x in range(x_start, x_end):
				for y in range(y_start, y_end):
					if get_cell_atlas_coords(0, Vector2i(x, y), 0) == tile["debug_path"]:
						set_cell(0, Vector2i(x, y), 0, tile["floor"])
