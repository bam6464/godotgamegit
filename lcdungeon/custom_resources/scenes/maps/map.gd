class_name Map
extends Node2D

const SCROLL_SPEED:= 15
const MAP_ROOM = preload("res://custom_resources/scenes/maps/map_room.tscn")
const MAP_LINE = preload("res://custom_resources/scenes/maps/map_line.tscn")

@onready var map_generator: MapGenerator= $MapGenerator
@onready var lines: Node2D= %Lines
@onready var rooms: Node2D= %Rooms
@onready var visuals: Node2D= %VisualsMap
@onready var camera_2d: Camera2D= $Camera2D

var map_data: Array[Room]
var floors_completed: int
var last_room: Room
var camera_edge_x: float

func _ready() -> void:
	camera_edge_x= MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH-1)
	generate_new_map()

func generate_new_map() -> void:
	floors_completed= 0
	map_data = map_generator.generate_map()
	create_map()
	
func create_map() -> void:	
	#spawn rooms
	for room: Room in map_data:
		if room.column < MapGenerator.MAP_WIDTH-1:
			_spawn_room(room)
	#spawn stairs
	_spawn_room(map_data[MapGenerator.MAP_WIDTH-1])
	
	var map_width_px := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH-1)
	visuals.position.x = ((get_viewport_rect().size.x - map_width_px)/2)
	visuals.position.y = (get_viewport_rect().size.y /1.5)
	
func unlock_next_rooms()-> void:
	for map_room: MapRoom in rooms.get_children():
		if last_room.column == MapGenerator.MAP_WIDTH-1:
			hide_map()
			get_tree().change_scene_to_file("res://custom_resources/scenes/mainMenu/win_screen.tscn") 
			#todo clear map room
			#hide_map()
			#map_data = []
			#generate_new_map()
			#show_map()
		elif last_room.next_room.column == map_room.room.column:
			map_room.available= true
	
func show_map()-> void:
	show()
	camera_2d.enabled= true
	
func hide_map()-> void:
	hide()
	camera_2d.enabled= false
			
func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	if room.column==0:
		new_map_room.available= true
	new_map_room.clicked.connect(_on_map_room_clicked)
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)

func _connect_lines(room: Room)-> void:
	if room.column < map_generator.MAP_WIDTH -1:
		var new_map_line:= MAP_LINE.instantiate() as Line2D
		new_map_line.clear_points()
		new_map_line.add_point(room.position)
		#print("room column %s, position %s, next %s", room.column, room.position, room.next_room.position)
		new_map_line.add_point(room.next_room.position)
		lines.add_child(new_map_line)
	
func _on_map_room_clicked(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.column == room.column:
			map_room.available = false
			last_room = room
			unlock_next_rooms()

func _on_map_room_selected(room: Room) -> void:
	last_room = room
	floors_completed += 1
	#Events.map_exited.emit(room)
