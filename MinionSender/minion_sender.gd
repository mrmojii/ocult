extends Node2D

var is_player_near = false

func _process(delta: float) -> void:
	if is_player_near && Input.is_action_just_pressed("Interact"):
		print("send minions")
		GameManager.start_fight()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	is_player_near = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name != "Player" : 
		return
	is_player_near = false
	
