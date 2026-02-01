class_name DanceArrow
extends Node2D

enum ArrowType
{
	Right = 0,
	Left,
	Top,
	Bot
}

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var type : ArrowType = ArrowType.Right
var speed : float = 330.0
var is_paused : bool = false
var direction := Vector2(0, 1)
var is_in_zone := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		ArrowType.Left: sprite_2d.rotation_degrees = 180
		ArrowType.Bot: sprite_2d.rotation_degrees = 90
		ArrowType.Top: sprite_2d.rotation_degrees = 270

func _physics_process(delta: float) -> void:
	var velocity := Vector2.ZERO
	if !is_paused:
		velocity = speed * direction * delta
	
	position += velocity

func set_type(_type : int) -> void:
	type = _type
	match type:
		ArrowType.Right: sprite_2d.rotation_degrees = 0
		ArrowType.Left: sprite_2d.rotation_degrees = 180
		ArrowType.Bot: sprite_2d.rotation_degrees = 90
		ArrowType.Top: sprite_2d.rotation_degrees = 270
