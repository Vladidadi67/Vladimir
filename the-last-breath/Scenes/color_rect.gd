extends ColorRect

var colors = [
	Color(0.02, 0.05, 0.1),   # deep icy blue
	Color(0.05, 0.1, 0.18),   # cold blue
	Color(0.08, 0.15, 0.22)   # frozen cyan tint
]

var index = 0

func _ready():
	color = colors[0]
	loop_colors()

func loop_colors():
	var next_index = (index + 1) % colors.size()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "color", colors[next_index], 8.0)

	await tween.finished
	index = next_index
	loop_colors()
