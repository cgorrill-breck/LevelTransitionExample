extends CharacterBody2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction  = 1
var damage = 10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if not check_at_edge():
		scale.x *= -1  # only flip the X scale
		direction *= -1

		
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func get_damage() -> int:
	return damage	

func check_at_edge() -> bool:
	if ray_cast_2d.is_colliding():
		print("colliding")
		return true
	else:
		print("stopping")
		return false
