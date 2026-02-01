class_name Circle
extends Node2D

const POINT = preload("uid://743mwpx3gf6w")

@export var radius : float = 150.0
@export var points_number : int = 6
@export var line_base : Line2D
@export var lines : Node2D
@export var rules : Array[CircleRule]

@onready var center: Area2D = $Center
@onready var pentagram: Area2D = $Pentagram

enum CircleState
{
	Idle = 0,
	MakingLine
}

var state : CircleState = CircleState.Idle

var _points : Array[Point]
var _is_active := false

var _new_line : Line2D = null
var _first_point : Point = null

var _connected_points : Array[Vector2i]

var has_pentagram := false
var _items : Array[Interactable]
var _item_current : int
var _mask : Interactable

var _str : int = 0
var _agi : int = 0
var _int : int = 0

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.RED, false)

func _ready() -> void:
	_create_points()

func _process(delta: float) -> void:
	if state == CircleState.MakingLine:
		_move_new_line()

func _move_new_line() -> void:
	if !_new_line:
		state = CircleState.Idle
		return
	
	if _new_line.points.size() != 2:
		_new_line.queue_free()
		_new_line = null
		state = CircleState.Idle
		return
	
	_new_line.points[1] = PlayerManager.player.global_position
	
func _create_points() -> void:
	var step = 360 / points_number
	var angle = 180
	for i in range(points_number):
	
		var _point = POINT.instantiate()
		add_child(_point)
		var _angle = deg_to_rad(angle)
		_point.position = Vector2(sin(_angle) * radius, radius * cos(_angle)) 
		_point.point_id = i
		_points.push_back(_point)
		angle -= step

func on_active() -> void:
	_is_active = true

func on_disable() -> void:
	_is_active = false

func on_select_point(point : Point) -> void:
	match state:
		CircleState.Idle: _create_line(point)
		CircleState.MakingLine: _connect_line(point)
		
func _create_line(point : Point) -> void:
	if _new_line or state != CircleState.Idle:
		return

	state = CircleState.MakingLine
	_first_point = point
	_new_line = line_base.duplicate()
	_new_line.points[0] = point.global_position
	_new_line.points.push_back(PlayerManager.player.global_position)
	lines.add_child(_new_line)
	_new_line.global_position = Vector2.ZERO

func _connect_line(point) -> void:
	if !_new_line or !_first_point or state != CircleState.MakingLine:
		return
	
	if _first_point == point:
		_new_line.queue_free()
		_new_line = null
		_first_point = null
		state = CircleState.Idle
		return
	
	_connected_points.push_back(Vector2i(point.point_id, _first_point.point_id))
	
	point.is_selected = true
	_first_point.is_selected = true
	
	_new_line.points[1] = point.global_position
	_new_line = null
	_first_point = null
	state = CircleState.Idle
	
	check_for_rules()

func _sort_connected_points() -> void:
	
	for i in range(_connected_points.size()):
		if _connected_points[i].x > _connected_points[i].y:
			var t = _connected_points[i].x
			_connected_points[i].x = _connected_points[i].y
			_connected_points[i].y = t

func check_for_rules() -> void:
	var found_rule : int = -1
	_sort_connected_points()
	
	for i in range(rules.size()):
		var rule = rules[i].rule
		if rule.size() != _connected_points.size():
			continue
		var not_found := false
		for r in rule:
			if _connected_points.find(r) == -1:
				not_found = true
				break
		if not_found:
			continue
		else:
			found_rule = i
			has_pentagram = true
			#print("FOUND RULE: %s" % rules[i].name)

func has_mask_in_the_center() -> bool:
	for i in center.get_overlapping_bodies():
		if i is Interactable and i.data.id == 0:
			_mask = i
			return true
	return false

func update_items_pentagram() -> void:
	_items.clear()
	_item_current = 0
	for i in pentagram.get_overlapping_bodies():
		if i is Interactable:
			_items.push_back(i)

func hit_the_note() -> void:
	if _items.is_empty():
		return
	
	if _item_current >= _items.size():
		return
	
	_items[_item_current].spawn_good_label()
	if _items[_item_current].power >= 6:
		_item_current += 1

func miss_the_note() -> void:
	if _items.is_empty():
		return
	
	if _item_current >= _items.size():
		return
	
	_items[_item_current].spawn_bad_label()

func clear_circle() -> void:
	for p in _points:
		p.is_selected = false
	
	_connected_points.clear()
	for c in lines.get_children():
		if c is Line2D:
			c.queue_free()

func clear_items() -> void:	
	_str = 0
	_agi = 0
	_int = 0
	
	for i in _items:
		match i.data.id:
			1: _int += 8 + (i.power * 2)
			2: _str += 8 + (i.power * 2)
			3: _agi += 8 + (i.power * 2)
		i.queue_free()
	if _mask:
		_mask.queue_free()
	
	print("str: %d, agi: %d, int: %d" % [_str, _agi, _int])
