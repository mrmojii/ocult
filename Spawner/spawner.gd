class_name Spawner
extends StaticBody2D

const INTERACTABLE = preload("uid://bk5x5jvt5gnxo")
@export var item_data : ItemData
@export var sprite:Sprite2D
#TODO: we need to create a Resource for each type of the Item, 
#otherwise it will be pain in the ass to code

func _ready() -> void:
	sprite.texture = item_data.image_texute
	sprite.scale = Vector2(0.5,0.5)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hover_spawner(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.unhover_spawner(self)

func on_hover() -> void:
	pass

func on_unhover() -> void:
	pass

func on_interact() -> void:
	var item = INTERACTABLE.instantiate()
	item.data = item_data
	get_tree().current_scene.add_child(item)
	
	PlayerManager.player.pickup_interactable(item)
