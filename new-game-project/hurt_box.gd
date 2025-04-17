extends Area2D
class_name HurtBox
signal hurt(hitbox : HitBox, damage: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hurtbox layers:", get_collision_layer(), " mask:", get_collision_mask())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(hitbox: HitBox, damage: int):
	hurt.emit(hitbox, damage)

func _on_area_entered(hitbox: HitBox) -> void:
	print("hit")
	if not hitbox is HitBox:
		return
	take_damage(hitbox, hitbox.get_parent().damage)
	pass # Replace with function body.
