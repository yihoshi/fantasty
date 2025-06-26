extends Area2D

@export var slime_speed : float = -50
@export var animator : AnimatedSprite2D
var is_dead : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_dead:
		position += Vector2(slime_speed,0) * delta
	if position.x < -225:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_dead:
		body.game_over()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		animator.play("death")
		$DeathSound.play()
		area.queue_free()
		is_dead = true
		get_tree().current_scene.score += 1
		
		await animator.animation_finished
		queue_free()
