class_name SkullClass extends Node2D

enum Type {
	Normal,
	Archer,
	Warrior,
	Wizard
}

const _TEXTURES := {
	Type.Normal: preload("res://Fight/assets/normal.png"),
	Type.Archer: preload("res://Fight/assets/archer.png"),
	Type.Warrior: preload("res://Fight/assets/warrior.png"),
	Type.Wizard: preload("res://Fight/assets/wizard.png"),
}

# Setters
var _type: Type = Type.Normal
func set_type(type: Type) -> void:
	_type = type
	$Sprite.texture = _TEXTURES[type]
	
# Getters
func get_height() -> int:
	return $Sprite.texture.get_height()
