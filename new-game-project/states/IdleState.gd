extends BaseState

func _enter():
	player.velocity.x = 0
	player.animated_sprite.play("idle")
	player.jumps_remaining = player.data.MAX_JUMPS_ALLOWED

func _physics_process(delta):
	if not player.is_on_floor():
		player.switch_state(player.states.fall)
		return

	var dir = Input.get_axis("left", "right")
	if dir != 0:
		player.switch_state(player.states.run)
	elif Input.is_action_just_pressed("jump"):
		player.can_jump(delta)
		player.switch_state(player.states.jump)
