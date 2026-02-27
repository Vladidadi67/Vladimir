extends CanvasLayer

@onready var oxygen_bar = $OxygenBar
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player:
		oxygen_bar.value = player.oxygen
