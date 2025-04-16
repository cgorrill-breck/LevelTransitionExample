extends BaseState

var timer = 0.0

func _enter():
	player.velocity = Vector2(
		player.data.WALL_JUMP_FORCE.x * sign(player.wall_normal.x),
		player.data.WALL_JUMP_FORCE.y
	)
	timer = player.data.WALL_JUMP_DURATION
	player.animated_sprite.play("jump")

func _physics_process(delta):
	timer -= delta
	player.velocity.y += player.data.GRAVITY * delta

	if timer <= 0:
		player.switch_state(player.states.fall)
