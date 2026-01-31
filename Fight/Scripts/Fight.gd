extends Node2D

const FIGHTER_SCENE := preload("res://Fight/Fighter/Fighter.tscn")

var _i_current_spawn:int = 0

const op_chars = [
	{ "type": FighterClass.Type.Normal,  "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": FighterClass.Type.Archer,  "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": FighterClass.Type.Warrior, "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": FighterClass.Type.Wizard,  "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
]

const my_chars = [
	{ "type": FighterClass.Type.Normal,  "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": FighterClass.Type.Archer,  "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": FighterClass.Type.Warrior, "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": FighterClass.Type.Wizard,  "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
]

func _ready():
	$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	if _i_current_spawn >= my_chars.size() && _i_current_spawn >= op_chars.size():
		$SpawnTimer.stop()
		return
	
	if _i_current_spawn < my_chars.size():
		_spawn_fighter($FighterStartMe.position, FighterClass.Sides.Me, my_chars[_i_current_spawn])
		
	if _i_current_spawn < op_chars.size():
		_spawn_fighter($FighterStartOp.position, FighterClass.Sides.Op, op_chars[_i_current_spawn])
		
	_i_current_spawn = _i_current_spawn + 1

func _spawn_fighter(pos:Vector2, side:FighterClass.Sides, fighter:Variant):
	var fighter_instance = FIGHTER_SCENE.instantiate() as FighterClass
	fighter_instance.set_characteristic(side, fighter.type)
	fighter_instance.position = pos
	$FighterContainer.add_child(fighter_instance)
