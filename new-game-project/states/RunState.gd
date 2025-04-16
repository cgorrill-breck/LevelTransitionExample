extends BaseState

func _enter():
	player.animated_sprite.play("run")
	player.jumps_remaining = player.data.MAX_JUMPS_ALLOWED

func _physics_process(delta):
	var dir = Input.get_axis("left", "right")
	player.velocity.x = dir * player.data.SPEED
	player.animated_sprite.scale.x = 1 if dir > 0 else -1

	if not player.is_on_floor():
		player.switch_state(player.states.fall)
	elif dir == 0:
		player.switch_state(player.states.idle)
	elif Input.is_action_just_pressed("jump"):
		player.switch_state(player.states.jump)
