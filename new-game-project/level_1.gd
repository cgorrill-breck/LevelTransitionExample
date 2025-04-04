extends Node2D
class_name Level1
@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var goal_collision: CollisionShape2D = $goal/GoalCollision
@onready var goal_shape: Polygon2D = $goal/GoalCollision/GoalShape
@export var next_level : PackedScene

signal level_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_goal_area_entered(area: Area2D) -> void:
	print("on goal")
	level_complete.emit()


func _on_goal_body_entered(body: Node2D) -> void:
	print("on goal")
	level_complete.emit()
	pass # Replace with function body.
