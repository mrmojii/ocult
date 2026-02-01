extends Node2D

@export var player : Player
@onready var request_timer = %RequestTimer
@onready var clock = %Label

func _ready() -> void:
	PlayerManager.player = player
	GameManager.init()
	GameManager.current_request_changed.connect(_on_current_request_changed)


func _on_request_timer_timeout() -> void:
	GameManager.tick_time()
	clock.text = str(GameManager.request_remaining_time)
	pass # Replace with function body.

func _on_current_request_changed():
	GameManager.request_remaining_time = GameManager.request_duration
	request_timer.start()
