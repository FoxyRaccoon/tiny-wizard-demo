@tool
class_name Room
extends Node2D

enum Direction {RIGHT, DOWN, LEFT, UP}
enum Status {UNEXPLORED, EXPLORED}

const ROOM_SIZE = Vector2(1024,600)

const OPEN_DOORS = [
	preload("res://tiny_wizard/assets/placeholder_art/Doors/right_door.png"),
	preload("res://tiny_wizard/assets/placeholder_art/Doors/down_door.png"),
	preload("res://tiny_wizard/assets/placeholder_art/Doors/left_door.png"),
	preload("res://tiny_wizard/assets/placeholder_art/Doors/up_door.png"),
]

const CLOSED_DOORS = [
	preload("res://tiny_wizard/assets/placeholder_art/Doors/right_door_closed.png"),
	preload("res://tiny_wizard/assets/placeholder_art/Doors/down_door_closed.png"),
	preload("res://tiny_wizard/assets/placeholder_art/Doors/left_door_closed.png"),
	preload("res://tiny_wizard/assets/placeholder_art/Doors/up_door_closed.png"),
]

const PLAYER_CHARACTER = preload("res://tiny_wizard/player/player_character.tscn")
const GUI_SCENE = preload("res://tiny_wizard/gui/gui.tscn")
const HOLE_AREA = preload("res://foxyraccoon_tiny_wizard/world/hole_area.tscn")

@onready var doors = [
	$RoomWalls/RightDoor,
	$RoomWalls/DownDoor,
	$RoomWalls/LeftDoor,
	$RoomWalls/UpDoor,
]

@onready var spawn_points = [
	$RightSpawnPoint,
	$DownSpawnPoint,
	$LeftSpawnPoint,
	$UpSpawnPoint,
]


@export var hide_right_door := false
@export var hide_down_door := false
@export var hide_left_door := false
@export var hide_up_door := false

var room_pos := Vector2i.ZERO

var ice_floor := false

signal door_entered(direction)

func _ready():
	# This spawns the player if launching the scene from the editor
	# This allows to run the room and test it without having to launch the game
	if get_tree().current_scene == self:
		var player_node = PLAYER_CHARACTER.instantiate()
		add_child(player_node)
		player_node.position = spawn_points[0].position
		enter_room()
		var gui = GUI_SCENE.instantiate()
		add_child(gui)
		player_node.gui_path = gui.get_path()
		set_holes()
		
	if randf() > 0.8:
		ice_floor = true


# Get the position of the room on the level matrix: (0,0), (0,1)...
func get_room_matrix_position()->Vector2i:
	return room_pos

func get_room_global_position()->Vector2:
	return global_position

func get_room_rect()->Rect2:
	return Rect2(
		global_position,
		ROOM_SIZE
	)

func update_doors():
	if hide_right_door: _hide_door(Direction.RIGHT)
	if hide_down_door: _hide_door(Direction.DOWN)
	if hide_left_door: _hide_door(Direction.LEFT)
	if hide_up_door: _hide_door(Direction.UP)

func set_holes():
	for tile in $TileMap.get_used_cells(0):
		var tile_id = $TileMap.get_cell_atlas_coords(0,tile)
		if tile_id.x !=4:
			var hole = HOLE_AREA.instantiate()
			hole.position = (tile * 63) + Vector2i(40,50)
			add_child(hole)

func get_spawning_point(direction):
	var dir = Direction.UP
	if direction.x > 0:
		dir = Direction.RIGHT
	if direction.y > 0:
		dir = Direction.DOWN
	if direction.x < 0:
		dir = Direction.LEFT
	
	return spawn_points[dir]

func enter_room():
	var enemies = $Enemies.get_children()
	if enemies.size() > 0:
		# Wake up Enemies
		for enemy in enemies:
			enemy.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		
		# Close doors
		for d in [Direction.RIGHT, Direction.DOWN, Direction.LEFT, Direction.UP]:
			close_door(d)
	if ice_floor:
		get_node("../../Character").physics_stats.friction = 0.02
		$RoomWalls.modulate = Color(0, 1, 1)
		$TileMap.modulate = Color(0, 1, 1)
	else:
		get_node("../../Character").physics_stats.friction = 0.2
		$RoomWalls.modulate = Color(1, 1, 1)
		$TileMap.modulate = Color(1, 1, 1)

func enter_door(_body, door_direction):
	door_entered.emit(door_direction)

func _hide_door(direction):
	var door = doors[direction]
	door.get_node("Locker").collision_layer = 1
	door.visible = false

func close_door(direction:Direction):
	doors[direction].texture = CLOSED_DOORS[direction]
	(doors[direction].get_node("Locker") as StaticBody2D).collision_layer = 1

func open_door(direction:Direction):
	doors[direction].texture = OPEN_DOORS[direction]
	(doors[direction].get_node("Locker") as StaticBody2D).collision_layer = 0


func _on_enemies_child_exiting_tree(node):
	# If it is the last enemy (see godotengine/godot #59210)
	if $Enemies.get_child_count() == 1:
		for d in [Direction.RIGHT, Direction.DOWN, Direction.LEFT, Direction.UP]:
			open_door(d)

