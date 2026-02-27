extends ColorRect

var time := 0.0

func _process(delta):
	time += delta
   
	var alpha_wave = 0.06 + sin(time * 0.3) * 0.02
	color.a = alpha_wave
