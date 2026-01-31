class_name Player
extends CharacterBody2D

@export var drop_point : Marker2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var _interactables : Array[Interactable]
var _hovered_interactalbe : Interactable
var _picked_interactable : Interactable
var _hovered_point : Point
var _selected_point : Point
var _selected_circle : Circle

func add_interactable(obj : Interactable) -> void:
	_interactables.push_back(obj)
	if _interactables.size() == 1:
		_hovered_interactalbe = _interactables[0]
		_hovered_interactalbe.on_hover()

func remove_interactable(obj : Interactable) -> void:
	_interactables.erase(obj)
	if _interactables.is_empty():
		_hovered_interactalbe.on_unhover()
		_hovered_interactalbe = null

func hover_point(point : Point) -> void:
	if _hovered_point:
		_hovered_point.is_hovered = false
	_hovered_point = point
	_hovered_point.is_hovered = true

func unhover_point(point : Point) -> void:
	point.is_hovered = false
	if _hovered_point and _hovered_point == point:
		_hovered_point = null

func _process(delta: float) -> void:
	_update_interactables()
	_move_picked()

func _move_picked() -> void:
	if !_picked_interactable:
		return
	
	_picked_interactable.position = drop_point.global_position
		
func _update_interactables() -> void:
	if _interactables.is_empty() or _picked_interactable:
		return
	
	var distance = position.distance_to(_hovered_interactalbe.position)
	var closest = _hovered_interactalbe
	for i in _interactables:
		var d = position.distance_to(i.position)
		if d < distance:
			distance = d
			closest = i
	
	if closest != _hovered_interactalbe:
		_hovered_interactalbe.on_unhover()
		_hovered_interactalbe = closest
		_hovered_interactalbe.on_hover()

func _physics_process(delta: float) -> void:
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("MoveLeft", "MoveRight")
	direction.y = Input.get_axis("MoveUp", "MoveDown")
	direction = direction.normalized()

	velocity = SPEED * direction

	var collision = move_and_collide(velocity * delta)
	if collision:
			var other = collision.get_collider()
			if other is Interactable and !other.is_picked:
				var push_dir = collision.get_normal()
				var push_force : float = 100.0
				other.add_push(push_force, -push_dir)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if not _interact_interactable():
			_interact_point()

func _interact_interactable() -> bool:
	if _picked_interactable:
		_picked_interactable.on_drop()
		_picked_interactable = null
		if _interactables.size() == 1:
			_hovered_interactalbe = _interactables[0]
			_hovered_interactalbe.on_hover()
		return true
	elif _hovered_interactalbe:
		_hovered_interactalbe.on_interact()
		_picked_interactable = _hovered_interactalbe
		return true
	return false

func _interact_point() -> void:
	if !_hovered_point:
		return
	
	var circle : Circle = _hovered_point.select_point()
