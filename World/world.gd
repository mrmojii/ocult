extends Node2D

@export var player : Player

func _ready() -> void:
	PlayerManager.player = player
