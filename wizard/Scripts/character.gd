extends CharacterBody2D

@export var move_speed : float = 100
@export var animator : AnimatedSprite2D
@export var bullet_scence : PackedScene
var is_game_over : bool = false
var is_attacking: bool = false

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over or is_attacking:
		$Running.stop()
	elif not $Running.playing:
		$Running.play()
	
func _physics_process(delta: float) -> void:
#前后左右移动
	if not is_game_over and not is_attacking:
		velocity = Input.get_vector("left","right","up","down") * move_speed
		if velocity.x != 0:
			animator.flip_h = velocity.x < 0 
		if velocity == Vector2.ZERO:
			animator.play("idle")
		else :
			animator.play("run")

		move_and_slide()
	
# 检测鼠标左键点击
func _input(event):

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_on_fire()

#播放攻击动画并生成子弹
func _on_fire() -> void:
	if is_game_over or is_attacking:
		return
	is_attacking = true
	animator.play("attack")
	await get_tree().create_timer(0.6).timeout
	$On_Fire.play()
	_spawn_bullet()
	await animator.animation_finished
	is_attacking = false

#子弹生成逻辑	
func _spawn_bullet() -> void:
	var mouse_pos = get_screen_transform().affine_inverse() * get_viewport().get_mouse_position()
	var bullet_node = bullet_scence.instantiate()
	var spawn_pos = position + (Vector2(-12, -6) if velocity.x < 0 else Vector2(6, -6))
	bullet_node.position = spawn_pos 
	var direction_to_mouse = (mouse_pos - spawn_pos).normalized()
	bullet_node.rotation = direction_to_mouse.angle()
	get_tree().current_scene.add_child(bullet_node)

func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("game_over")
		$Game_Over.play()
		get_tree().current_scene.show_game_over()
		await animator.animation_finished
		get_tree().reload_current_scene()
