extends Control


enum PAGES{
	MAIN,
	TUTORIAL_GAME_JAM
}

var current_page = PAGES.MAIN

@onready var main_page = %MainPage
@onready var tutorial_page = %TutorialPage
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.state_changed.connect(_on_game_state_changed)
	main_page.show()
	tutorial_page.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_state_changed(state:GameManager.GAME_STATE):
	if state == GameManager.GAME_STATE.START:
		show()
	else :
		hide()


func _on_quit_button_button_up() -> void:
	print("button up")
	get_tree().quit()
	pass # Replace with function body.


func _on_start_main_button_button_up() -> void:
	main_page.hide()
	tutorial_page.show()
	pass # Replace with function body.


func _on_continue_button_button_up() -> void:
	GameManager.state = GameManager.GAME_STATE.PLAY
	GameManager.start_level()
	pass # Replace with function body.
