extends CharacterBody2D

# ===== MOVEMENT SETTINGS =====
const SPEED := 200.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 900.0

# ===== OXYGEN SYSTEM =====
var oxygen := 100.0
var oxygen_drain_rate := 5.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Left / Right movement
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	# Drain oxygen over time
	oxygen -= oxygen_drain_rate * delta
	oxygen = clamp(oxygen, 0.0, 100.0)

	if oxygen <= 0.0:
		die()

func add_oxygen(amount):
	oxygen += amount
	oxygen = clamp(oxygen, 0.0, 100.0)

func die():
	print("You died")
	get_tree().reload_current_scene()
