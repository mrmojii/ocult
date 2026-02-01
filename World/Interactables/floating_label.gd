extends Node2D

@export var label : Label

@onready var timer: Timer = $Timer

var direction := Vector2(0, -1)
var speed := 200.0
var min_time := 1.5
var max_time := 2.3

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = rng.randf_range(min_time, max_time)
	timer.start()
	
	direction = Vector2(rng.randf_range(-0.2, 0.2), -1)
	direction = direction.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	modulate.a -= delta * 0.8

func make_red() -> void:
	label.text = "-1"
	label.modulate = Color.RED

func make_green() -> void:
	label.text = "+1"
	label.modulate = Color.GREEN


func _on_timer_timeout() -> void:
	queue_free()
