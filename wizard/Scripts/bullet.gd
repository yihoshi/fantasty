extends Area2D
@export var bullet_speed : float = 150

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * bullet_speed * delta

#超出屏幕后销毁
func screen_exited() -> void:
	queue_free()
