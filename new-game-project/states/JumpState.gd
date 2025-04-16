extends BaseState

func _enter():
	player.velocity.y = player.data.JUMP_VELOCITY
	player.jumps_remaining -= 1
	player.animated_sprite.play("jump")

func _physics_process(delta):
	player.velocity.y += player.data.GRAVITY * delta

	if player.velocity.y > 0:
		player.switch_state(player.states.fall)
