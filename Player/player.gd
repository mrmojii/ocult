extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("MoveLeft", "MoveRight")
	direction.y = Input.get_axis("MoveUp", "MoveDown")
	direction = direction.normalized()

	velocity = SPEED * direction

	var collision = move_and_collide(velocity * delta)
	#move_and_slide()
	if collision:
		#for c in collisions:
		#for index in get_slide_collision_count():
			#var collision = get_slide_collision(index)
			var other = collision.get_collider()
			
			if other is Interactable:
				var push_dir = collision.get_normal()
				var push_force : float = 100.0
				other.add_push(push_force, -push_dir)
			
