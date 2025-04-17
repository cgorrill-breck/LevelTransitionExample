extends Area2D
class_name HitBox

var damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_damage()
	print("Hitbox layers:", get_collision_layer(), " mask:", get_collision_mask())
	pass # Replace with function body.

func set_damage():
	if get_parent().has_method("get_damage"):
		damage = get_parent().get_damage()
	else:
		damage = 10
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
