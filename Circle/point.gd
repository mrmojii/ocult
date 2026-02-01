class_name Point
extends Node2D

var radius : float = 10.0
var connected := false

var point_id : int = -1

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_hovered : bool = false:
	set(v):
		is_hovered = v
		
		if is_hovered:
			_color = Color.GREEN
		else:
			_color = Color.BLUE
		queue_redraw()
			
var _color := Color.BLUE

var is_selected : bool = false:
	set(v):
		is_selected = v
		
		if is_selected:
			sprite_2d.visible = false
			animated_sprite_2d.visible = true
		else:
			sprite_2d.visible = true
			animated_sprite_2d.visible = false

#func _draw() -> void:
	#draw_circle(Vector2.ZERO, radius, _color, true)

func _ready() -> void:
	is_hovered = false
	is_selected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hover_point(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.unhover_point(self)

func select_point() -> Circle:
	get_parent().on_select_point(self)
	return owner
