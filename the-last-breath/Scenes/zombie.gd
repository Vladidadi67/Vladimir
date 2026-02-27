extends CharacterBody2D

const SPEED := 120.0
const GRAVITY := 900.0

@onready var sprite = $AnimatedSprite2D
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Chase player
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * SPEED

		# Flip sprite
		if direction != 0:
			sprite.flip_h = direction < 0

		# Play walk animation
		if not sprite.is_playing():
			sprite.play("idle")
	else:
		velocity.x = 0
		sprite.stop()

	move_and_slide()
