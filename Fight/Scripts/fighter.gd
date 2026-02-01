class_name FighterClass
extends Node2D

@export var speed_x: float = 50.0

enum Type { Normal, Archer, Warrior, Wizard }
enum Sides { Me, Op }

# --- Tuning ---
const SHOT_RANGE := {
	Type.Normal:  50.0,
	Type.Archer:  600.0,
	Type.Warrior: 50.0,
	Type.Wizard:  300.0,
}

const TEXTURES := {
	Sides.Me: {
		Type.Normal:  preload("res://Fight/assets/normal.png"),
		Type.Archer:  preload("res://Fight/assets/archer.png"),
		Type.Warrior: preload("res://Fight/assets/warrior.png"),
		Type.Wizard:  preload("res://Fight/assets/wizard.png"),
	},
	Sides.Op: {
		Type.Normal:  preload("res://Fight/assets/normal_op.png"),
		Type.Archer:  preload("res://Fight/assets/archer_op.png"),
		Type.Warrior: preload("res://Fight/assets/warrior_op.png"),
		Type.Wizard:  preload("res://Fight/assets/wizard_op.png"),
	}
}

# --- State ---
var _type: Type = Type.Normal
var _side: Sides = Sides.Me
var _attack_tween: Tween
var _damage_tween: Tween


# ---------- Public API ----------
func set_characteristic(side: Sides, type: Type) -> void:
	_type = type
	_side = side
	_apply_visuals()
	_apply_shot_radius()

func get_height() -> int:
	return $Sprite.texture.get_height() if $Sprite.texture else 0

func get_side() -> Sides:
	return _side


# ---------- Lifecycle ----------
func _ready() -> void:
	$TimerAttack.wait_time = _rand_range(0.95, 1.05)

func _process(delta: float) -> void:
	var in_range := _has_enemy_in_range()

	if in_range:
		_ensure_attack_timer_running()
	else:
		_stop_attack_timer()
		_move_forward(delta)


# ---------- Combat logic ----------
func _has_enemy_in_range() -> bool:
	for area in $ShotCollision.get_overlapping_areas():
		if area.name != "HitBox":
			continue

		var fighter := area.get_parent() as FighterClass
		if fighter != null and fighter._side != _side:
			return true

	return false


# ---------- Movement / timer ----------
func _move_forward(delta: float) -> void:
	var dir := 1.0 if _side == Sides.Me else -1.0
	position.x += dir * delta * speed_x

func _ensure_attack_timer_running() -> void:
	if $TimerAttack.is_stopped():
		$TimerAttack.start()

func _stop_attack_timer() -> void:
	if not $TimerAttack.is_stopped():
		$TimerAttack.stop()


# ---------- Visual setup ----------
func _apply_visuals() -> void:
	$Sprite.texture = TEXTURES[_side][_type]

func _apply_shot_radius() -> void:
	# Duplicate shape so each instance has its own radius
	$ShotCollision/CollisionShape2D.shape = $ShotCollision/CollisionShape2D.shape.duplicate()
	var circle := $ShotCollision/CollisionShape2D.shape as CircleShape2D
	if circle:
		circle.radius = SHOT_RANGE[_type]


# ---------- Attack animation ----------
func _on_timer_attack_timeout() -> void:
	# prevent stacking tweens
	if _attack_tween and _attack_tween.is_valid():
		_attack_tween.kill()

	_attack_tween = create_tween()
	_attack_tween.tween_property(self, "scale", Vector2(1.2, 0.8), 0.06)
	_attack_tween.tween_property(self, "scale", Vector2.ONE, 0.08)
	
# ---------- Damage animation --------------
func _on_damage() -> void:
	# prevent stacking tweens
	if _damage_tween and _damage_tween.is_valid():
		_damage_tween.kill()

	_damage_tween = create_tween()
	_damage_tween.tween_property($Sprite, "modulate", Color(1.5, 0.0, 0.0, 1.0), 0.05)
	_damage_tween.tween_property($Sprite, "modulate", Color.WHITE, 0.1)

# ---------- Utils ----------
func _rand_range(a: float, b: float) -> float:
	return a + randf() * (b - a)
