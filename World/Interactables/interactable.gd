class_name Interactable
extends RigidBody2D

@export var push_force : float = 15.0
@export var mu_static = 0.8  # friction coefficients
@export var mu_moving = 0.5  # pushing something moving is easier
@export var weight : float = 16000.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var is_picked := false

func add_push(force: float, direction : Vector2) -> void:
	apply_impulse(direction * push_force * force)

func _physics_process(delta: float) -> void:
	if self.linear_velocity.length() == 0:
		apply_force(- self.weight * mu_static * self.linear_velocity.normalized())
	else:
		apply_force(- self.weight * mu_moving * self.linear_velocity.normalized())


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_interactable(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.remove_interactable(self)

func on_hover() -> void:
	sprite_2d.modulate = Color.RED

func on_unhover() -> void:
	sprite_2d.modulate = Color.WHITE

func on_interact() -> void:
	sprite_2d.modulate = Color.WHITE
	is_picked = true
	freeze = true
	sleeping = true
	collision_shape_2d.disabled = true

func on_drop() -> void:
	is_picked = false
	freeze = false
	sleeping = false
	collision_shape_2d.disabled = false
