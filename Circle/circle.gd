class_name Circle
extends Node2D

const POINT = preload("uid://743mwpx3gf6w")

@export var radius : float = 150.0
@export var points_number : int = 6

var _points : Array[Point]
var _is_active := false

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.RED, false)

func _ready() -> void:
	_create_points()

func _create_points() -> void:
	var step = 360 / points_number
	var angle = 180
	for i in range(points_number):
	
		var _point = POINT.instantiate()
		add_child(_point)
		var _angle = deg_to_rad(angle)
		_point.position = Vector2(sin(_angle) * radius, radius * cos(_angle)) 
		angle -= step

func on_active() -> void:
	_is_active = true

func on_disable() -> void:
	_is_active = false
