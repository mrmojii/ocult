class_name Interactable
extends RigidBody2D

@export var push_force : float = 20.0
@export var mu_static = 0.8  # friction coefficients
@export var mu_moving = 0.5  # pushing something moving is easier
@export var weight : float = 8000.0

func add_push(force: float, direction : Vector2) -> void:
	apply_impulse(direction * push_force * force)

func _physics_process(delta: float) -> void:
	if self.linear_velocity.length() == 0:
		apply_force(- self.weight * mu_static * self.linear_velocity.normalized())
	else:
		apply_force(- self.weight * mu_moving * self.linear_velocity.normalized())
