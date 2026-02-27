extends Area2D
@export var oxygen_amount = 20

func _on_body_entered(body):
	if body.has_method("add_oxygen"):
		body.add_oxygen(oxygen_amount)
		queue_free()
