class_name Circle
extends Node2D

const POINT = preload("uid://743mwpx3gf6w")

@export var radius : float = 150.0
@export var points_number : int = 6
@export var line_base : Line2D
@export var lines : Node2D
@export var rules : Array[CircleRule]

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
	add_child(_new_line)
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
			print("FOUND RULE: %s" % rules[i].name)
