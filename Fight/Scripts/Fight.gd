class_name FightManager extends Node2D

# Public API
enum Result { Unknown, Win, Lose }

signal FightEnd(result:Result)

var my_chars: Array[FighterData] = []
var op_chars: Array[FighterData] = []

@onready var EndPanel = %EndPanel
@onready var TitleText = %TitleText

func Start():
	$SpawnTimer.start()
	
func Reset():
	%TitleText.set_text("")
	%EndPanel.hide()
	$SpawnTimer.stop()
	$EndChecker.stop()
	op_chars.clear()
	my_chars.clear()
	
	for child in $FighterContainer.get_children():
		child.queue_free()
	

# Private var
const _FIGHTER_SCENE := preload("res://Fight/Fighter/Fighter.tscn")
var _i_current_spawn:int = 0
var _result: Result = Result.Unknown

# Internal callbacks
func _ready():
	%EndPanel.hide()
	Start()

func _on_spawn_timer_timeout() -> void:
	if _i_current_spawn >= my_chars.size() && _i_current_spawn >= op_chars.size():
		$SpawnTimer.stop()
		$EndChecker.start()
		return
	
	if _i_current_spawn < my_chars.size():
		_spawn_fighter($FighterStartMe.position, FighterClass.Sides.Me, my_chars[_i_current_spawn])
		
	if _i_current_spawn < op_chars.size():
		_spawn_fighter($FighterStartOp.position, FighterClass.Sides.Op, op_chars[_i_current_spawn])
		
	_i_current_spawn = _i_current_spawn + 1

func _spawn_fighter(pos:Vector2, side:FighterClass.Sides, fighter_data:FighterData):
	var fighter_instance = _FIGHTER_SCENE.instantiate() as FighterClass
	fighter_instance.set_characteristic(side, fighter_data)
	fighter_instance.position = pos
	$FighterContainer.add_child(fighter_instance)

func _on_button_pressed() -> void:
	FightEnd.emit(_result)
	GameManager.end_fight(_result)

func _on_end_checker_timeout() -> void:
	var has_me := false
	var has_op := false

	for child in $FighterContainer.get_children():
		if child is not FighterClass or child.is_queued_for_deletion():
			continue

		var f := child as FighterClass
		match f.get_side():
			FighterClass.Sides.Me: has_me = true
			FighterClass.Sides.Op: has_op = true

		# early exit: both sides still present => battle continues
		if has_me and has_op:
			return
			
	# Decide result
	if not has_me and not has_op: _win() # no fighters left -> win (as you requested)
	elif has_me and not has_op: _win()   # only my side left -> win
	elif has_op and not has_me: _lose()  # only opponent left -> lost

func _win():
	_result = Result.Win
	
	$EndChecker.stop()
	%TitleText.set_text("The dungeon is safe")
	%EndPanel.show()
	
func _lose():
	_result = Result.Lose
	
	$EndChecker.stop()
	%TitleText.set_text("You have failed your duty")
	%EndPanel.show()
