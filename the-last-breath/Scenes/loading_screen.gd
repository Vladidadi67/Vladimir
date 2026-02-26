extends Node2D

@export var next_scene_path: String = "res://Scenes/Level1.tscn"

var progress := []
var loading := false

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)
	loading = true

func _process(delta):
	if loading:
		var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)

		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if progress.size() > 0:
				$ProgressBar.value = progress[0] * 100.0

		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(scene)
			loading = false
