extends RayCast2D
"""
Zombie AI (CharacterBody2D)
- Follows the Player (CharacterBody2D) in group: "Player"
- Jumps over obstacles detected in front
- Instantly kills the player on collision

SETUP (quick):
1) Put your Player node in group "Player" (Node -> Groups).
2) Add a RayCast2D as a child of the Zombie named "ObstacleRay":
   - Target Position: (20, 0) for right-facing detection (tweak as needed)
   - Enabled: true
   - Collision Mask: include ONLY walls/blocks/obstacles (not the Player)
3) Ensure the Player has a method: die()
   - If you don’t have it yet, either add it or connect to the signal `player_killed(player)` below.
4) Keep your existing animations on AnimatedSprite2D; this script won't change your flip logic.
"""

# --- Movement tuning ---
@export var speed: float = 120.0
@export var gravity: float = 900.0

# Jump tuning (obstacle handling)
@export var jump_velocity: float = -320.0          # negative = up in Godot 2D
@export var ray_distance: float = 22.0             # how far ahead to check for obstacles
@export var jump_cooldown: float = 0.25            # prevents infinite jump loops

signal player_killed(player)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var obstacle_ray: RayCast2D = $ObstacleRay

var player: CharacterBody2D = null
var _jump_cd: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

	# Make sure ray is enabled and has the right length.
	if obstacle_ray:
		obstacle_ray.enabled = true
		# Ray points to the right by default; we will flip it based on movement direction.
		obstacle_ray.target_position = Vector2(ray_distance, 0)

func _physics_process(delta: float) -> void:
	# Cooldown timer for jump spam protection
	_jump_cd = maxf(_jump_cd - delta, 0.0)

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta


	# Chase player
	var direction := 0.0
	if player and is_instance_valid(player):
		direction = signf(player.global_position.x - global_position.x)
		velocity.x = direction * speed

		# Flip sprite (keeps your existing logic)
		if direction != 0:
			sprite.flip_h = direction < 0

		# Update obstacle ray to point forward (in the direction of movement)
		_update_obstacle_ray(direction)

		# Jump over obstacle if detected
		_try_jump_over_obstacle(direction)

		# Animation: keep it simple and do not break your existing logic
		# (Your script played "idle" while moving; preserved to avoid breaking your setup.)
		if not sprite.is_playing():
			sprite.play("idle")
	else:
		velocity.x = 0
		sprite.stop()

	# Move
	move_and_slide()

	# After moving, check if we collided with player and kill instantly
	_check_player_collision_and_kill()

func _update_obstacle_ray(direction: float) -> void:
	if not obstacle_ray or direction == 0:
		return

	# Keep the ray "in front" of the zombie
	# If moving left, ray points left; if moving right, ray points right.
	obstacle_ray.target_position = Vector2(ray_distance * direction, 0)

func _try_jump_over_obstacle(direction: float) -> void:
	if not obstacle_ray or direction == 0:
		return
	if _jump_cd > 0.0:
		return
	if not is_on_floor():
		return

	# Only jump if there's something directly in front (a wall/block)
	# IMPORTANT: set the ray's collision mask so it doesn't see the player.
	if obstacle_ray.is_colliding():
		# Optional: if you want to avoid jumping at tiny bumps, you can add additional checks here.
		velocity.y = jump_velocity
		_jump_cd = jump_cooldown

func _check_player_collision_and_kill() -> void:
	# We use slide collisions so this works even if you don't use Area2D hitboxes.
	var count := get_slide_collision_count()
	for i in count:
		var col := get_slide_collision(i)
		if col == null:
			continue

		var other := col.get_collider()
		if other == null:
			continue

		# If we hit something in the Player group, kill instantly
		if other.is_in_group("Player"):
			_kill_player(other)
			return

func _kill_player(p: Object) -> void:
	# Prefer calling die() on the player if it exists
	if p.has_method("die"):
		p.call("die")
	else:
		# Fallback: emit signal so you can handle death in a GameManager / UI / etc.
		emit_signal("player_killed", p)
