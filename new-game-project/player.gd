extends CharacterBody2D


var is_on_wall_clinging = false
var wall_jump_lock_time = 0.2
var wall_normal = Vector2.ZERO


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var was_on_floor := is_on_floor()
@onready var coyote_time: Timer = $CoyoteTime
@onready var camera_2d: Camera2D = $Camera2D

@export var jump_buffer_time := 0.125
@export var data : PlayerData


var jump_buffer_remaining := 0.0
var animation_direction = "right"
var in_coyote_time = false
var jumps_remaining : int

func _ready() -> void:
	camera_2d.limit_bottom = get_viewport_rect().size.y
	camera_2d.limit_right = get_viewport_rect().size.x
	jumps_remaining = data.MAX_JUMPS_ALLOWED

func _physics_process(delta: float) -> void:
	if wall_jump_lock_time > 0:
		wall_jump_lock_time -= delta
	handle_jump(delta)  # << move jump BEFORE movement!
	if wall_jump_lock_time <= 0:
		handle_animation(handle_movement(delta))  # Only allow movement control if not locked
	apply_gravity(delta)
	move_and_slide()

func handle_movement(delta):
	if wall_jump_lock_time > 0:
		return sign(velocity.x)  # skip movement control entirely

	var direction := Input.get_axis("left", "right")
	var is_airborne = not is_on_floor()

	var accel: float
	var friction: float

	if is_airborne:
		# If you're trying to reverse direction midair, use lower acceleration
		if sign(direction) != sign(velocity.x) and direction != 0 and abs(velocity.x) > 20:
			accel = data.AIR_TURN_ACCELERATION
		else:
			accel = data.ACCELERATION_AIR
		friction = data.FRICTION_AIR
	else:
		accel = data.ACCELERATION_GROUND
		friction = data.FRICTION_GROUND

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * data.SPEED, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

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
		jumps_remaining = data.MAX_JUMPS_ALLOWED

	var can_jump := is_on_floor() or in_coyote_time or jumps_remaining > 0
	handle_wall_cling()
	if jump_buffer_remaining > 0:
		if can_jump:
			velocity.y = data.JUMP_VELOCITY
			jump_buffer_remaining = 0

			if is_on_floor() or in_coyote_time:
				jumps_remaining -= 1
			else:
				jumps_remaining = 0

			in_coyote_time = false

		elif is_on_wall_clinging:
			velocity = Vector2(data.WALL_JUMP_FORCE.x * sign(wall_normal.x), data.WALL_JUMP_FORCE.y)
			wall_jump_lock_time = data.WALL_JUMP_DURATION
			jump_buffer_remaining = 0
			print("WALL JUMP! Direction: ", wall_normal, " | Velocity: ", velocity)


	   
func handle_wall_cling():
	is_on_wall_clinging = false
	wall_normal = Vector2.ZERO  # reset it every frame

	if is_on_wall_only():
		var input_dir = Input.get_axis("left", "right")

		# Only cling if pushing into wall
		if (get_wall_normal().x > 0 and input_dir < 0) or (get_wall_normal().x < 0 and input_dir > 0):
			animated_sprite_2d.scale.x = get_wall_normal().x * -1 #make the sprite face the wall
			is_on_wall_clinging = true
			wall_normal = get_wall_normal()
			velocity.y = min(velocity.y, data.WALL_SLIDE_SPEED)



func apply_gravity(delta):
	#cut vertical velocity if jump is not pressed.
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y *= 0.5  # or 0.6–0.8 for less dramatic cutoff
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
		if is_on_wall_clinging:
			animation_name = "wall_cling"
		elif velocity.y < 0:
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

func _on_hurt_box_hurt(hitbox: HitBox, damage: int) -> void:
	print("HIT")
	queue_free()
