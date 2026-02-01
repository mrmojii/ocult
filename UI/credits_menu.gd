extends Control


@onready var result_label = %WinOrLose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.state_changed.connect(_on_game_state_changed)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_state_changed(state:GameManager.GAME_STATE):
	if state == GameManager.GAME_STATE.END:
		if GameManager.is_win == true :
			result_label.text = "You won!"
		else : 
			result_label.text = "You lost..."
		show()
	else :
		hide()


func _on_quit_button_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
