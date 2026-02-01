extends Node2D

@export var circle : Circle

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		is_active = true
		body._hovered_clear = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		is_active = false
		body._hovered_clear = false

func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return
	if event.is_action_pressed("Interact"):
		circle.clear_circle()
