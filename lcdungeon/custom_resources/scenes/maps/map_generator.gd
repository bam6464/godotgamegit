class_name MapGenerator 
extends Node

#pixel horizontal distance between rooms
const X_DIST:= 190
#pixel vertical distance between rooms
const Y_DIST:= 65
#number of columns (horizontally)
const MAP_WIDTH:= 5
const PATHS:= 1
const ABNO_ROOM_WEIGHT:= 10.0 
const HEAL_ROOM_WEIGHT:= 2.5
const EVENT_ROOM_WEIGHT:= 4.0

var random_room_type_weights= {
	Room.Type.ABNO: 0.0,
	Room.Type.HEAL: 0.0,
	Room.Type.EVENT: 0.0
}
var random_room_type_total_weight:= 0
#contains the room in a given map, before was an Array[Array], as in, Row[Column]
#but it is not needed as we have one single floor/row, and we need to know only about the Column id
var map_data: Array[Room]

func generate_map() -> Array:
	#create map
	map_data = _generate_initial_grid()

	#establish link between room and next room, cyclying through all rooms in the map
	for room in map_data:
		_setup_connection(room)
	
	#last room in the map, stairs
	var stairs= map_data[MAP_WIDTH-1] as Room
	stairs.type = Room.Type.STAIRS
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data
	
func _setup_connection(cur_room: Room) -> void:
	var next_room: Room
	if cur_room.column < MAP_WIDTH-1:
		next_room = map_data[cur_room.column+1]
		cur_room.next_room = next_room
	else:
		return 
	return 
	
func _generate_initial_grid() -> Array[Room]:
	var result: Array[Room]
	
	for j in MAP_WIDTH:
		var current_room:= Room.new()
		current_room.position= Vector2(j * X_DIST +1, j * -Y_DIST)
		current_room.column= j
		result.append(current_room)
	return result

func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.ABNO]= ABNO_ROOM_WEIGHT
	random_room_type_weights[Room.Type.HEAL]= HEAL_ROOM_WEIGHT + ABNO_ROOM_WEIGHT
	random_room_type_weights[Room.Type.EVENT]= EVENT_ROOM_WEIGHT + ABNO_ROOM_WEIGHT + HEAL_ROOM_WEIGHT
	
	random_room_type_total_weight= random_room_type_weights[Room.Type.EVENT]
	
func _setup_room_types() -> void:
	for room in map_data:
		if room.column == 0:
			room.type = Room.Type.ABNO
		if room.column < MAP_WIDTH -1:
			if room.next_room.type == Room.Type.NOT_ASSIGNED:
				room.next_room.type= _set_room_randomly()

func _set_room_randomly() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	return Room.Type.ABNO
