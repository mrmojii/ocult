class_name Point
extends Node2D


var radius : float = 10.0
var connected := false

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.BLUE, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
