extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -460.0
const MAX_JUMPS_ALLOWED = 2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var was_on_floor := is_on_floor()
@onready var coyote_time: Timer = $CoyoteTime

@export var jump_buffer_time := 0.125

var jump_buffer_remaining := 0.0
var animation_direction = "right"
var in_coyote_time = false
var jumps_remaining = MAX_JUMPS_ALLOWED

func _physics_process(delta: float) -> void:
	handle_jump(delta)
	apply_gravity(delta)
	handle_animation(handle_movement())
	move_and_slide()

func handle_movement():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	return direction
	
func handle_coyote_time():
	if was_on_floor and not in_coyote_time and not is_on_floor():
		coyote_time.start()
		in_coyote_time = true
	elif is_on_floor():
		in_coyote_time = false
	was_on_floor = is_on_floor()

func handle_jump(delta):
	handle_coyote_time()
	handle_jump_buffering(delta)
	if is_on_floor():
		jumps_remaining = MAX_JUMPS_ALLOWED

	var can_jump := is_on_floor() or in_coyote_time or jumps_remaining > 0

	if jump_buffer_remaining > 0 and can_jump:
		velocity.y = JUMP_VELOCITY
		jump_buffer_remaining = 0

		if is_on_floor() or in_coyote_time:
			jumps_remaining -= 1
		else:
			jumps_remaining = 0

		in_coyote_time = false
	
	

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	

func handle_jump_buffering(delta):
	if Input.is_action_just_pressed("jump"):
		jump_buffer_remaining = jump_buffer_time
	
	if jump_buffer_remaining > 0:
		jump_buffer_remaining -= delta
	
func handle_animation(direction):
	var animation_name = ""

	if not is_on_floor():
		if velocity.y < 0:
			animation_name = "jump"
		else:
			animation_name = "fall"
	elif direction == 0:
		animation_name = "idle"
	else:
		animation_name = "run"
		animated_sprite_2d.scale.x = 1 if direction > 0 else -1

	animated_sprite_2d.play(animation_name)

func _on_coyote_time_timeout() -> void:
	in_coyote_time = false
