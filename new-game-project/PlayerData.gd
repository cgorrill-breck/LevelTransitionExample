# PlayerData.gd
class_name PlayerData
extends Resource

# Movement
@export var SPEED := 200.0
@export var ACCELERATION_GROUND := 1000.0
@export var ACCELERATION_AIR := 600.0
@export var AIR_TURN_ACCELERATION := 500.0
@export var FRICTION_GROUND := 800.0
@export var FRICTION_AIR := 300.0

# Jumping
@export var JUMP_VELOCITY := -460.0
@export var MAX_JUMPS_ALLOWED := 2
@export var GRAVITY := 1200.0

# Wall Mechanics
@export var WALL_SLIDE_SPEED := 40.0
@export var WALL_JUMP_FORCE := Vector2(300, -460)
@export var WALL_JUMP_DURATION := 0.2

# Timers
@export var JUMP_BUFFER_TIME := 0.125
@export var COYOTE_TIME := 0.1
