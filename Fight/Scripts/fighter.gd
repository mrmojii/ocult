class_name FighterClass extends Node2D

# Public vars
@export var Speed_x: int = 50

# Public definitions
enum Type {
	Normal, Archer, Warrior, Wizard
}

enum Sides {
	Me, Op
}

# Assets
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

const _SHOT_RANGE := { 
	Type.Normal:  50,
	Type.Archer:  600,
	Type.Warrior: 50,
	Type.Wizard:  300,
}

# Privates
var _type: Type  = Type.Normal
var _side: Sides = Sides.Me

# Setters
func set_characteristic(side: Sides, type: Type) -> void:
	_type = type
	_side = side
	$Sprite.texture = _TEXTURES[side][type]
	$ShotCollision/CollisionShape2D.shape = $ShotCollision/CollisionShape2D.shape.duplicate()
	($ShotCollision/CollisionShape2D.shape as CircleShape2D).radius = _SHOT_RANGE[type]
	
# Getters
func get_height() -> int:
	return $Sprite.texture.get_height()
	
func get_side() -> Sides:
	return _side

# Api callbacks
func _process(delta: float) -> void:
	var found_enemy := false
	for area in $ShotCollision.get_overlapping_areas():
		if area.name != "HitBox":
			continue
			
		var fighter := area.get_parent() as FighterClass
		if fighter != null and fighter.get_side() != _side:
			found_enemy = true
			break

	if not found_enemy:
		var dir = +1 if _side == Sides.Me else -1
		position.x += dir * delta * Speed_x

func _on_timer_attack_timeout() -> void:
	pass # Replace with function body.
