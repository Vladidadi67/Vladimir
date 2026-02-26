extends Node2D

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/LoadingScreen.tscn")

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
