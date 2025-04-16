extends BaseState

func _enter():
	player.animated_sprite.play("fall")

func _physics_process(delta):
	# Apply gravity
	player.velocity.y += player.data.GRAVITY * delta

	# Jump cut: reduce upward velocity if jump is released early
	if player.velocity.y < 0 and not Input.is_action_pressed("jump"):
		player.can_jump(delta);
		player.velocity.y *= 0.5

	# Move left/right in air
	var dir = Input.get_axis("left", "right")
	if dir != 0:
		player.velocity.x = move_toward(
			player.velocity.x,
			dir * player.data.SPEED,
			player.data.ACCELERATION_AIR * delta
		)
	else:
		player.velocity.x = move_toward(
			player.velocity.x,
			0,
			player.data.FRICTION_AIR * delta
		)

	# Flip sprite
	if dir != 0:
		player.animated_sprite.scale.x = 1 if dir > 0 else -1

	# Wall cling check
	if player.is_on_wall_only() and not player.is_on_floor():
		var input_dir = Input.get_axis("left", "right")
		var wall_normal = player.get_wall_normal()
		if (wall_normal.x > 0 and input_dir < 0) or (wall_normal.x < 0 and input_dir > 0):
			player.wall_normal = wall_normal
			player.switch_state(player.states.wall_cling)
			return

	# Grounded again?
	if player.is_on_floor():
		player.jumps_remaining = player.data.MAX_JUMPS_ALLOWED
		player.switch_state(player.states.idle)
		return

	# Buffered jump midair
	if Input.is_action_just_pressed("jump") and player.jumps_remaining > 0:
		player.switch_state(player.states.jump)
