extends Node2D

var is_player_near = false

@onready var bubble_list = %HBoxContainer

func _ready() -> void:
	GameManager.minion_added.connect(_on_minion_sent)

func _process(delta: float) -> void:
	if is_player_near && Input.is_action_just_pressed("Interact"):
		print("send minions")
		GameManager.start_fight()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	is_player_near = true
	body._hovered_send = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name != "Player" : 
		return
	is_player_near = false
	body._hovered_send = false
	
func _on_minion_sent(minion:FighterData):
	#add  trect
	pass
