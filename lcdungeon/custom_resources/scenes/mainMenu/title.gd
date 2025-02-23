extends Control

@onready var continue_button: Button = %Continue
@onready var new_button: Button = %New
@onready var quit_button: Button = %Quit

func _ready()-> void:
	get_tree().paused = false

func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_new_pressed() -> void:
	get_tree().change_scene_to_file("res://custom_resources/scenes/mainMenu/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
