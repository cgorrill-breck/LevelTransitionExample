extends BaseState

func _enter():
	player.animated_sprite.play("wall_cling")  # Could use a wall cling animation too

func _physics_process(delta):
	player.velocity.y = min(player.velocity.y, player.data.WALL_SLIDE_SPEED)
	var input_dir = Input.get_axis("left", "right")
	player.wall_normal = player.get_wall_normal()

	if Input.is_action_just_pressed("jump"):
		player.switch_state(player.states.wall_jump)
	elif not player.is_on_wall_only():
		player.switch_state(player.states.fall)
