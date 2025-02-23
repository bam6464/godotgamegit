extends Control

func _on_dungeon_pressed() -> void:
	get_tree().change_scene_to_file("res://custom_resources/scenes/maps/map.tscn")
