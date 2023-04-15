extends Node2D



var _current_room := Vector2i.ZERO

const ROOM_LIST = [
	preload("res://tiny_wizard/room/room.tscn"),
	preload("res://tiny_wizard/room/room_types/room_1.tscn"),
	preload("res://tiny_wizard/room/room_types/room_2.tscn"),
	preload("res://tiny_wizard/room/room_types/room_3.tscn"),
	preload("res://tiny_wizard/room/room_types/room_4.tscn"),
	preload("res://tiny_wizard/room/room_types/room_5.tscn"),
	preload("res://tiny_wizard/room/room_types/room_6.tscn"),
	preload("res://tiny_wizard/room/room_types/room_7.tscn"),
	preload("res://tiny_wizard/room/room_types/room_8.tscn"),
	preload("res://tiny_wizard/room/room_types/room_9.tscn"),
	preload("res://tiny_wizard/room/room_types/room_10.tscn"),
]

var rooms = {}

var level = 5

func _ready():
	if ResourceLoader.exists("user://save.tres"):
		var save = load("user://save.tres")
		level = save.level
	
	print(level)
	
	gen_rooms(level)
	
	for room in $Rooms.get_children():
		room.door_entered.connect(self.move_camera)
		
		var room_pos = Vector2i((room.global_position - Vector2(0,200)) / room.ROOM_SIZE)
		rooms[room_pos] = room
		room.room_pos = room_pos
	
	
		
	for room_pos in rooms:
		var room = rooms[room_pos]
		room.hide_right_door = !rooms.has(room_pos + Vector2i.RIGHT)
		room.hide_down_door = !rooms.has(room_pos + Vector2i.DOWN)
		room.hide_left_door = !rooms.has(room_pos + Vector2i.LEFT)
		room.hide_up_door = !rooms.has(room_pos + Vector2i.UP)
		room.update_doors()
		room.set_holes()

func gen_rooms(size):
	var rooms_array = []
	for i in range(size):
		rooms_array.append([])
		for j in range(size):
			rooms_array[i].append(-1)
	rooms_array[int(size/2)][int(size/2)] = 0
	if not recursive_gen(Vector2(int(size/2), int(size/2)), rooms_array, false):
		var further = Vector2(int(size/2), int(size/2))
		for i in range(size):
			for j in range(size):
				if rooms_array[i][j] != -1:
					if Vector2(i,j).distance_to(Vector2(int(size/2), int(size/2))) >= further.distance_to(Vector2(int(size/2), int(size/2))):
						further = Vector2(i,j)
		rooms_array[further.x][further.y] = 10
	print(rooms_array)
	for i in range(size):
		for j in range(size):
			if rooms_array[i][j] != -1:
				var local_room = ROOM_LIST[rooms_array[i][j]].instantiate()
				local_room.position = Vector2((j-int(size/2))*1024, (i-int(size/2))*600+200)
				$Rooms.add_child(local_room)

func recursive_gen(room_position, rooms_array, exit):
	var neighbors = [Vector2(-1,0), Vector2(1,0), Vector2(0,1), Vector2(0,-1)]
	for neighbor in neighbors:
		var new_pos = room_position + neighbor
		if new_pos.x >= 0 and new_pos.x < rooms_array.size() and new_pos.y >= 0 and new_pos.y < rooms_array.size() and rooms_array[new_pos.x][new_pos.y] == -1 and check_neighbors(new_pos, rooms_array, -neighbor) and randf() > 0.6:
			rooms_array[new_pos.x][new_pos.y] = randi_range(1, ROOM_LIST.size()-1)
			if rooms_array[new_pos.x][new_pos.y] == 10:
				return true
			else:
				exit = recursive_gen(new_pos, rooms_array, exit)
	return exit

func check_neighbors(room_position, rooms_array, exclude):
	var neighbors = [Vector2(-1,0), Vector2(1,0), Vector2(0,1), Vector2(0,-1)]
	for neighbor in neighbors:
		if exclude.y != neighbor.y or exclude.x != neighbor.x:
			var new_pos = room_position + neighbor
			if new_pos.x >= 0 and new_pos.x < rooms_array.size() and new_pos.y >= 0 and new_pos.y < rooms_array.size() and rooms_array[new_pos.x][new_pos.y] != -1:
				return false
	return true
	
func move_camera(direction):
	
	_current_room += Vector2i(direction)
	var next_room = get_room(_current_room)
	print(
		"Entering Room ", get_current_room().get_room_matrix_position(), 
		" at position ", get_current_room().get_global_position(),
		" covering area ", get_current_room().get_room_rect()
		)
	$Camera2D.position += direction*next_room.ROOM_SIZE
	$Character.global_position = next_room.get_spawning_point(direction).global_position
	next_room.enter_room()


func get_room(room_coord: Vector2i):
	if rooms.has(room_coord):
		return rooms[room_coord]
	else:
		return null

func get_current_room():
	return get_room(_current_room)
