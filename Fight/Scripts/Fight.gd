extends Node2D

const SKULL_SCENE := preload("res://Fight/Skulls/Skull.tscn")

const my_chars = [
	{ "type": SkullClass.Type.Normal, "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": SkullClass.Type.Archer, "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": SkullClass.Type.Warrior, "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
	{ "type": SkullClass.Type.Wizard, "stats": {"hp":100, "strength":10, "agility":10, "intelligence":10} },
]

func _ready():
	var current_y = $SkullStart.position.y
	
	for char in my_chars:
		var skull_instance = SKULL_SCENE.instantiate() as SkullClass
		skull_instance.set_type(char.type)
		skull_instance.position = Vector2($SkullStart.position.x, current_y)
		current_y += 70
		$SkullContainer.add_child(skull_instance)
