extends Area2D
# Crystal pickup: restores player's oxygen and removes itself.

@export var oxygen_amount: int = 15

# If your player uses different property names, change these:
@export var oxygen_property_name: StringName = &"oxygen"
@export var max_oxygen_property_name: StringName = &"max_oxygen"

var _picked := false

func _ready() -> void:
	# Safety: ensure we don't fire multiple times due to physics overlap.
	monitoring = true

func _on_body_entered(body: Node) -> void:
	if _picked:
		return

	if body == null:
		return

	# Make sure only the player can pick it up
	if not body.is_in_group("player"):
		return

	_picked = true

	# --- Apply oxygen ---
	# Preferred: if player has a method, use it
	if body.has_method("add_oxygen"):
		body.call("add_oxygen", oxygen_amount)
	else:
		# Fallback: directly modify oxygen/max_oxygen properties
		var current = body.get(oxygen_property_name)
		var max_o2 = body.get(max_oxygen_property_name)

		# If properties don't exist, do nothing (prevents crashes)
		if typeof(current) == TYPE_NIL or typeof(max_o2) == TYPE_NIL:
			# Still remove the crystal so it doesn't soft-lock the player
			_finish_pickup()
			return

		var new_value: int = int(current) + oxygen_amount
		new_value = min(new_value, int(max_o2))
		body.set(oxygen_property_name, new_value)

	# --- Remove crystal safely ---
	_finish_pickup()

func _finish_pickup() -> void:
	# Stop triggering immediately
	monitoring = false
	set_deferred("monitorable", false)

	# Remove after this frame (safe inside signal callback)
	queue_free()
