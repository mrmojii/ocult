class_name FighterClass
extends Node2D

enum Type  { Normal, Archer, Warrior, Wizard }
enum Sides { Me, Op }

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
# --- Tuning ---
@export var speed_x: float = 50.0

@export var SHOT_RANGE := {
	Type.Normal:  50.0,
	Type.Archer:  600.0,
	Type.Warrior: 50.0,
	Type.Wizard:  300.0,
}

@export var AFFINITY := {
	Type.Archer: {
		Type.Wizard:  1.5,
		Type.Warrior: 0.5,
		Type.Archer:  1.0,
		Type.Normal:  1.0,
	},
	Type.Wizard: {
		Type.Warrior: 1.5,
		Type.Archer:  0.5,
		Type.Wizard:  1.0,
		Type.Normal:  1.0,
	},
	Type.Warrior: {
		Type.Archer:  1.5,
		Type.Wizard:  0.5,
		Type.Warrior: 1.0,
		Type.Normal:  1.0,
	},
	Type.Normal: {
		Type.Archer:  1.0,
		Type.Wizard:  1.0,
		Type.Warrior: 1.0,
		Type.Normal:  1.0,
	},
}

# --- State ---
var _type: Type = Type.Normal
var _side: Sides = Sides.Me
var _attack_tween: Tween
var _damage_tween: Tween
var _target: FighterClass
var _current_hp: int = 0
var _stats: Variant

# ---------- Public API ----------
func set_characteristic(side: Sides, type: Type, stats: Variant) -> void:
	_type = type
	_side = side
	_stats = stats
	_current_hp = _stats.hp
	_apply_shot_radius()
	_apply_visuals()
	
func take_hit(dmg: int) -> void:
	_current_hp -= dmg
	$Health.set_value(100.0 * _current_hp / _stats.hp)
	_damage_anim()
	
	if _current_hp <= 0:
		queue_free()

func get_height() -> int:
	return $Sprite.texture.get_height() if $Sprite.texture else 0

func get_side() -> Sides:
	return _side
	
func get_type() -> Type:
	return _type

# ---------- Lifecycle ----------
func _ready() -> void:
	$Health.set_value(100.0)
	$TimerAttack.wait_time = _rand_range(0.95, 1.05)

func _process(delta: float) -> void:
	_target = get_closest_in_range()
	
	if _target != null:
		_ensure_attack_timer_running()
	else:
		_stop_attack_timer()
		_move_forward(delta)

# ---------- Combat logic ----------
func _get_hit_value() -> int:
	var dmg := 0.0

	match _type:
		Type.Normal:  dmg = 5 + _stats.strength
		Type.Warrior: dmg = 8 + _stats.strength * 1.5
		Type.Archer:  dmg = (4 + _stats.agility * 1.2) * randf_range(0.8, 1.2)
		Type.Wizard:  dmg = (3 + _stats.intelligence * 2.0) * randf_range(0.65, 1.35)
		
	return int(round(dmg))
	
func get_closest_in_range() -> FighterClass:
	var best: FighterClass = null
	var best_d2 := INF

	for area in $ShotCollision.get_overlapping_areas():
		if area.name != "HitBox":
			continue

		var f := area.get_parent() as FighterClass
		if f == null or f._side == _side:
			continue
		if not is_instance_valid(f):
			continue

		var d2 := global_position.distance_squared_to(f.global_position)
		if d2 < best_d2:
			best_d2 = d2
			best = f
			
	return best

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
	_target = get_closest_in_range()
	if _target == null:
		_stop_attack_timer()
		return

	_play_attack_anim()
	_target.take_hit(_get_hit_value() * AFFINITY[_type][_target.get_type()])
	
# ---------- Animations --------------
func _play_attack_anim() -> void:
	if _attack_tween and _attack_tween.is_valid():
		_attack_tween.kill()

	_attack_tween = create_tween()
	_attack_tween.tween_property(self, "scale", Vector2(1.2, 0.8), 0.06)
	_attack_tween.tween_property(self, "scale", Vector2.ONE, 0.08)
		
func _damage_anim() -> void:
	# prevent stacking tweens
	if _damage_tween and _damage_tween.is_valid():
		_damage_tween.kill()

	_damage_tween = create_tween()
	_damage_tween.tween_property($Sprite, "modulate", Color(1.5, 0.0, 0.0, 1.0), 0.05)
	_damage_tween.tween_property($Sprite, "modulate", Color.WHITE, 0.1)

# ---------- Utils ----------
func _rand_range(a: float, b: float) -> float:
	return a + randf() * (b - a)
