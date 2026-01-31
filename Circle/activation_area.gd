class_name ActivationArea
extends Node2D

@export var time : float = 3.0
@export var circle : Circle

@onready var timer: Timer = $Timer

var is_active : bool = false:
	set(v):
		is_active = v
		
		if is_active:
			_draw_color = Color.GREEN
		else:
			_draw_color = Color.BLUE
		queue_redraw()
			
var _draw_color := Color.BLUE

func _draw() -> void:
	draw_rect(Rect2(Vector2(-64,-32), Vector2(128,64)), _draw_color, false, 5.0)

func _ready() -> void:
	timer.wait_time = time
	
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hover_activation_area(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.unhover_activation_area(self)
