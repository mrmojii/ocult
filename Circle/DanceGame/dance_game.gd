extends Node2D

signal MissArrow()

const ARROW = preload("uid://dtxk1jdo3mg7h")

@export var keys : Array[DanceTimestamp]

var arrows_amount : int = 20
var max_wait_time : float = 1.0
var min_wait_time : float = 0.1

@onready var timer: Timer = $Timer
@onready var timer_start: Timer = $TimerStart
@onready var arrows: Node2D = $Arrows
@onready var label: Label = $Label

@onready var button_right: Sprite2D = $ButtonRight
@onready var button_left_2: Sprite2D = $ButtonLeft2
@onready var button_up: Sprite2D = $ButtonUp
@onready var button_down: Sprite2D = $ButtonDown


const _time_start_wait : float = 3.0
var _time_step : float = 0.0
var _arrows_left : int = 0
var _is_playing := true
var _wait_time : float = 0.0

var _markers : Array[Marker2D]
var _current : int = 0
var _score : int = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		if c is Marker2D:
			_markers.push_back(c)
	
	start()

func start() -> void:
	_arrows_left = keys.size()
	_current = 0
	timer_start.wait_time = _time_start_wait
	timer_start.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_start_timeout() -> void:
	_is_playing = true
	timer.wait_time = keys[0].time
	timer.start()


func _on_timer_timeout() -> void:
	_spawn_arrow()
	_arrows_left -= 1
	_current += 1
	
	if _arrows_left > 0:
		var wait_time = keys[_current].time - keys[_current - 1].time
		timer.wait_time = wait_time
		timer.start()
	

func _spawn_arrow() -> void:
	for i in range(4):
		var has_value := false
		#i hate myself for doing this
		match i:
			0 : has_value = keys[_current].keys.x == 1
			1: has_value = keys[_current].keys.y == 1
			2: has_value = keys[_current].keys.z == 1
			3: has_value = keys[_current].keys.w == 1
		
		if has_value:
			var arrow = ARROW.instantiate()
			arrows.add_child(arrow)
			arrow.set_type(i)
			arrow.global_position = _markers[i].global_position
			

func _unhandled_input(event: InputEvent) -> void:
	var hit := false
	var was_input := false
	
	if event.is_action_released("MoveRight"):
		button_right.modulate = Color.WHITE
	
	if event.is_action_released("MoveLeft"):
		button_left_2.modulate = Color.WHITE
	
	if event.is_action_released("MoveUp"):
		button_up.modulate = Color.WHITE
	
	if event.is_action_released("MoveDown"):
		button_down.modulate = Color.WHITE
	
	if event.is_action_pressed("MoveRight"):
		button_right.modulate = Color.GREEN
		was_input = true
		for c in arrows.get_children():
			if c is DanceArrow:
				if c.is_in_zone and c.type == 0:
					hit = true
					_hit_correctly()
					c.is_in_zone = false
					c.queue_free()
	if event.is_action_pressed("MoveLeft"):
		button_left_2.modulate = Color.GREEN
		was_input = true
		for c in arrows.get_children():
			if c is DanceArrow:
				if c.is_in_zone and c.type == 1:
					hit = true
					_hit_correctly()
					c.is_in_zone = false
					c.queue_free()
	if event.is_action_pressed("MoveDown"):
		button_down.modulate = Color.GREEN
		was_input = true
		for c in arrows.get_children():
			if c is DanceArrow:
				if c.is_in_zone and c.type == 3:
					hit = true
					_hit_correctly()
					c.is_in_zone = false
					c.queue_free()
	if event.is_action_pressed("MoveUp"):
		button_up.modulate = Color.GREEN
		was_input = true
		for c in arrows.get_children():
			if c is DanceArrow:
				if c.is_in_zone and c.type == 2:
					hit = true
					_hit_correctly()
					c.is_in_zone = false
					c.queue_free()
	
	if !hit and was_input:
		_hit_miss()

func _hit_correctly() -> void:
	_score += 10
	label.text = "%03d" % _score

func _hit_miss() -> void:
	_score -= 10
	_score = clamp(_score, 0, 9999999)
	label.text = "%03d" % _score

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is DanceArrow:
		var _arrow = area.get_parent() as DanceArrow
		_arrow.is_in_zone = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is DanceArrow:
		var _arrow = area.get_parent() as DanceArrow
		if _arrow.is_in_zone:
			_hit_miss()
			MissArrow.emit()
			_arrow.is_in_zone = false
			_arrow.queue_free()
