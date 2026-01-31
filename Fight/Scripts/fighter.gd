class_name FighterClass extends Node2D

@export var Speed_x: int = 50

enum Type {
	Normal,
	Archer,
	Warrior,
	Wizard
}

enum Sides {
	Me, Op
}

const _TEXTURES := { 
	Sides.Me: {
		Type.Normal: preload("res://Fight/assets/normal.png"),
		Type.Archer: preload("res://Fight/assets/archer.png"),
		Type.Warrior: preload("res://Fight/assets/warrior.png"),
		Type.Wizard: preload("res://Fight/assets/wizard.png"),
	},
	Sides.Op: {
		Type.Normal: preload("res://Fight/assets/normal_op.png"),
		Type.Archer: preload("res://Fight/assets/archer_op.png"),
		Type.Warrior: preload("res://Fight/assets/warrior_op.png"),
		Type.Wizard: preload("res://Fight/assets/wizard_op.png"),
	}
}

# Setters
var _type: Type = Type.Normal
var _side: Sides = Sides.Me
func set_characteristic(side: Sides, type: Type) -> void:
	_type = type
	_side = side
	$Sprite.texture = _TEXTURES[side][type]
	
# Getters
func get_height() -> int:
	return $Sprite.texture.get_height()
	
func _process(delta: float) -> void:
	var sign = +1 if _side == Sides.Me else -1
	position.x += sign * delta * Speed_x
