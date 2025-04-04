extends Node2D
class_name Level1
@export var next_level : PackedScene

signal level_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
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
