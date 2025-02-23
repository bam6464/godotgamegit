class_name Room
extends Resource

enum Type {NOT_ASSIGNED, ABNO, EVENT, HEAL, SHOP, STAIRS}

@export var type: Type
@export var column: int
@export var position: Vector2
@export var next_room: Room
@export var selected := false

func _to_string() -> String:
	return "%s (%s)" % [column, Type .keys()[type][0]]
