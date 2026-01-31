extends Node2D


func _draw() -> void:
	draw_rect(Rect2(Vector2(-64,-32), Vector2(128,64)), Color.GREEN, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
