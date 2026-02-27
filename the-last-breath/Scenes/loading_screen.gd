extends Node2D   # If your root is Control, change this to extends Control

@onready var progress_bar = $ProgressBar

var load_progress := 0.0

func _process(delta):
	if load_progress < 100:
		load_progress += 10 * delta   # speed (increase if too slow)
		progress_bar.value = load_progress
	else:
		get_tree().change_scene_to_file("res://Scenes/Level.tscn")
