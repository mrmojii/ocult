extends Node

enum GAME_STATE {
	START,
	PLAY,
	PAUSE,
	END
}

var is_win = false

var FightScene = preload("res://Fight/Fight.tscn")

@export var maximum_life = 3
@export var current_life = maximum_life:
	set(value):
		current_life = value
		if current_life <= 0:
			is_win = false
			state = GAME_STATE.END

@export var number_of_completed_requests_needed = 3
@export var number_of_completed_requests = 0:
	set(value):
		number_of_completed_requests = value
		if number_of_completed_requests >= number_of_completed_requests_needed:
			is_win = true
			state = GAME_STATE.END


enum ENNEMY_TYPE { Normal, Archer, Warrior, Wizard }

signal state_changed
signal reset_stage
signal current_request_changed

var current_request:Array[ENNEMY_TYPE]
var minion_roster = [FighterData]

var fight_scene:FightManager

var state = GAME_STATE.START:
	set(value):
		state = value
		
		state_changed.emit(state)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		if state == GAME_STATE.PLAY:
			state = GAME_STATE.PAUSE
		elif state == GAME_STATE.PAUSE:
			state = GAME_STATE.PLAY
	pass

func init():
	self.state = GAME_STATE.START

func reset():
	reset_stage.emit()	
	
func start_level():
	if fight_scene:
		fight_scene.queue_free()
	create_boss_request(4)
	
func complete_request(success:bool):
	if success:
		self.number_of_completed_requests += 1
	else:
		self.current_life -= 1
	reset()
	
func create_boss_request(numberOfEnnemies):
	current_request = []
	for i in range(numberOfEnnemies):
		current_request.append(ENNEMY_TYPE.values()[randi() % ENNEMY_TYPE.size()])
	print("current_request",current_request)
	current_request_changed.emit()

func start_fight():
	fight_scene = FightScene.instantiate()
	get_tree().current_scene.add_child(fight_scene)
	
func end_fight(result:FightManager.Result):
	if result == FightManager.Result.Win:
		complete_request(true)
	elif result == FightManager.Result.Lose:
		complete_request(false)
		
	
