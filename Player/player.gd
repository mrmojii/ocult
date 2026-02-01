class_name Player
extends CharacterBody2D

const UNIT = preload("uid://con7xjy3pv3iv")

@export var drop_point: Marker2D
@export var camera: Camera2D
@export var dance_game : DanceGame
@export var circle : Circle
@export var unit_move_point : Marker2D

@onready var animation_tree = %AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var _interactables: Array[Interactable]
var _hovered_interactalbe: Interactable
var _picked_interactable: Interactable
var _hovered_point: Point
var _selected_point: Point
var _selected_circle: Circle
var _activation_area: ActivationArea

var _hovered_spawner: Spawner

var _is_activating := false
var _activation_time: float = 0.0
var _moving_camera_back := false

var _controls_locked := false



func _ready() -> void:
	dance_game.Finished.connect(_on_dance_finished)
	PlayerManager.circle = circle

func add_interactable(obj: Interactable) -> void:
	_interactables.push_back(obj)
	if _interactables.size() == 1:
		_hovered_interactalbe = _interactables[0]
		_hovered_interactalbe.on_hover()

func remove_interactable(obj: Interactable) -> void:
	_interactables.erase(obj)
	if _interactables.is_empty():
		_hovered_interactalbe.on_unhover()
		_hovered_interactalbe = null

func hover_point(point: Point) -> void:
	if _hovered_point:
		_hovered_point.is_hovered = false
	_hovered_point = point
	_hovered_point.is_hovered = true

func unhover_point(point: Point) -> void:
	point.is_hovered = false
	if _hovered_point and _hovered_point == point:
		_hovered_point = null

func hover_spawner(spawner: Spawner) -> void:
	if _hovered_spawner:
		_hovered_spawner.on_unhover()
	_hovered_spawner = spawner

func unhover_spawner(spawner: Spawner) -> void:
	spawner.on_unhover()
	if spawner == _hovered_spawner:
		_hovered_spawner = null

func _process(delta: float) -> void:
	_update_interactables()
	_move_picked()
	
	if _is_activating and _activation_area:
		camera.global_position = lerp(camera.global_position, _activation_area.circle.global_position + Vector2(0, 70), 0.03)
		camera.zoom = lerp(camera.zoom, Vector2(1.07, 1.07), 0.03)
	
	if _moving_camera_back:
		camera.global_position = lerp(camera.global_position, global_position, 0.03)
		camera.zoom = lerp(camera.zoom, Vector2(3.0, 3.0), 0.03)
		if global_position.distance_to(camera.global_position) <= 1.0:
			_moving_camera_back = false

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
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("MoveLeft", "MoveRight")
	direction.y = Input.get_axis("MoveUp", "MoveDown")
	direction = direction.normalized()
	
	animation_tree.active = true
	
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/run/blend_position",direction)
		animationState.travel("run")
	else: 
		animationState.travel("idle")
	if !_controls_locked:
		velocity = SPEED * direction

	var collision = move_and_collide(velocity * delta)
	if collision:
			var other = collision.get_collider()
			if other is Interactable and !other.is_picked:
				var push_dir = collision.get_normal()
				var push_force: float = 100.0
				other.add_push(push_force, -push_dir)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if not _interact_interactable():
			_interact_point()
			_interact_activation_area()
			_interact_spawner()
	
	if event.is_action_released("Interact"):
		_release_activation_area()

func _interact_interactable() -> bool:
	if _picked_interactable:
		_picked_interactable.on_drop()
		_picked_interactable = null
		if _interactables.size() == 1:
			_hovered_interactalbe = _interactables[0]
			_hovered_interactalbe.on_hover()
		return true
	elif _hovered_interactalbe:
		pickup_interactable(_hovered_interactalbe)
		return true
	return false

func pickup_interactable(item: Interactable) -> void:
	item.on_interact()
	_picked_interactable = item

func _interact_point() -> void:
	if !_hovered_point:
		return
	
	_hovered_point.select_point()
	
func _interact_spawner() -> void:
	if !_hovered_spawner:
		return
	
	_hovered_spawner.on_interact()

func _interact_activation_area() -> void:
	if !_activation_area:
		return
	
	if !_activation_area.timer.is_stopped():
		_activation_area.timer.stop()
	
	_activation_area.timer.start()
	_is_activating = true
	_moving_camera_back = false
	
func _release_activation_area() -> void:
	if !_activation_area or _controls_locked:
		return
		
	if !_activation_area.timer.is_stopped():
		_activation_area.timer.stop()
		print("too early!")
	_is_activating = false
	_moving_camera_back = true

func _on_activation_area_timer() -> void:
	if circle.has_pentagram:
		if circle.has_mask_in_the_center():
			_controls_locked = true
			circle.update_items_pentagram()
			dance_game.start()
			

func _on_dance_finished() -> void:
	_controls_locked = false
	_is_activating = false
	_moving_camera_back = true
	dance_game.visible = false
	dance_game._score = 0
	circle.clear_circle()
	circle.clear_items()
	
	var unit = UNIT.instantiate()
	get_tree().current_scene.add_child(unit)
	unit.global_position = circle.global_position
	unit.move_point = unit_move_point.global_position
	
	unit.set_str(circle._str)
	unit.set_agi(circle._agi)
	unit.set_int(circle._int)
	
	unit.timer.start()
	unit.get_unit_class()
	unit.set_sprite()
	
func hover_activation_area(area: ActivationArea) -> void:
	_activation_area = area
	area.is_active = true
	_activation_time = _activation_area.time
	_activation_area.timer.timeout.connect(_on_activation_area_timer)

func unhover_activation_area(area: ActivationArea) -> void:
	area.is_active = false
	_release_activation_area()
	_activation_area.timer.timeout.disconnect(_on_activation_area_timer)
	_activation_area = null
