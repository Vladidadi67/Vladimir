extends ProgressBar

@export var next_scene_path: String = "res://Scenes/Level.tscn"

@onready var progress_bar = $ProgressBar

var progress := []

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(delta):
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = progress[0] * 100

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(scene)
