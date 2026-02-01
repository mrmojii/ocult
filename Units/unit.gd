class_name Unit
extends Node2D

@export var label_str : Label
@export var label_agi : Label
@export var label_int : Label

@export var timer : Timer

var move_point : Vector2 = Vector2.ZERO

var _is_moving := false
var _speed := 100.0

var stats_str : int = 0
var stats_agi : int = 0
var stats_int : int = 0
var stats_health : int = 100

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_str(25)
	set_agi(60)
	set_int(20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_str(str: int) -> void:
	label_str.text = "STR: %d" % str
	
	stats_str = str
	
	if str <= 20:
		label_str.modulate = Color.RED
	elif str <= 50:
		label_str.modulate = Color.ORANGE
	else:
		label_str.modulate = Color.GREEN

func set_agi(agi : int) -> void:
	label_agi.text = "AGI: %d" % agi
	
	stats_agi = agi
	
	if agi <= 20:
		label_agi.modulate = Color.RED
	elif agi <= 50:
		label_agi.modulate = Color.ORANGE
	else:
		label_agi.modulate = Color.GREEN

func set_int(_int : int) -> void:
	label_int.text = "INT: %d" % _int
	
	stats_int = _int
	
	if _int <= 20:
		label_int.modulate = Color.RED
	elif _int <= 50:
		label_int.modulate = Color.ORANGE
	else:
		label_int.modulate = Color.GREEN


func _physics_process(delta: float) -> void:
	if !_is_moving:
		return
	
	var dir = global_position.direction_to(move_point)
	position += dir * _speed * delta
	
	if global_position.distance_to(move_point) <= 20.0:
		GameManager.add_minion_to_roster(FighterData.Make(get_unit_class(), stats_health, stats_str,stats_agi, stats_int))
		queue_free()

func _on_timer_timeout() -> void:
	_is_moving = true

func get_unit_class() -> FighterClass.Type:
	if stats_str <= 20 and stats_agi <= 20 and stats_int <= 20:
		return FighterClass.Type.Normal
	
	if stats_str > 20 and stats_str > stats_agi and stats_str > stats_int:
		stats_health = 250
		return FighterClass.Type.Warrior

	if stats_agi > 20 and stats_agi > stats_str and stats_agi > stats_int:
		return FighterClass.Type.Archer
	
	if stats_int > 20 and stats_int > stats_str and stats_int > stats_agi:
		return FighterClass.Type.Wizard
	
	var random = rng.randi_range(1, 3)
	if random == FighterClass.Type.Warrior:
		stats_health = 250
	return random
