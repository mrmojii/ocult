extends Node

enum GAME_STATE {
	START,
	PLAY,
	PAUSE,
	END
}
signal state_changed

var state = GAME_STATE.START:
	set(value):
		state = value
		
		state_changed.emit(state)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.state = GAME_STATE.START
	
	pass
