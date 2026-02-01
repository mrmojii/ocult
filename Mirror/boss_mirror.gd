extends Node2D

@onready var bubble_list = %HBoxContainer
@onready var bubble_ui = %Control
@onready var timer = %sprite_add_timer
@onready var nine_patch_rect = %NinePatchRect

var player_in_front = false

var display = []
var texture_dictionnary = {
	GameManager.ENNEMY_TYPE.Normal: preload("res://Fight/Assets/Skeleton-export.png"),
	GameManager.ENNEMY_TYPE.Archer: preload("res://Fight/Assets/Archer_Skeleton-export.png"),
	GameManager.ENNEMY_TYPE.Warrior: preload("res://Fight/Assets/Warrior_Skeleton-export.png"),
	GameManager.ENNEMY_TYPE.Wizard: preload("res://Fight/Assets/Wizard_Skeleton-export.png"),
}

func _ready() -> void:
	GameManager.current_request_changed.connect(_on_request)

func _on_request():
	pass

func _process(delta: float) -> void:
	if GameManager.state != GameManager.GAME_STATE.PLAY:
		return
	if player_in_front == true && !bubble_ui.visible:
		bubble_ui.show()
		
	elif player_in_front == false && bubble_ui.visible:
		bubble_ui.hide()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_front = true
		print("coucou player")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_front = false
		print("adios player")
		


func _on_control_visibility_changed() -> void:
	if bubble_ui.visible : 
		for child in bubble_list.get_children():
			child.queue_free()
		var targets = GameManager.current_request
		nine_patch_rect.custom_minimum_size = Vector2(16 * targets.size(),0)
		for type in targets:
			var texture = texture_dictionnary.get(type)
			var text_rect = TextureRect.new()
			text_rect.texture = texture
			text_rect.stretch_mode = TextureRect.STRETCH_SCALE
			text_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			bubble_list.add_child(text_rect)
		
		#timer.start()
	else:
		for child in bubble_list.get_children():
			child.queue_free()
		#timer.stop()


func _on_sprite_add_timer_timeout() -> void:
	print("display stuff")
	pass
