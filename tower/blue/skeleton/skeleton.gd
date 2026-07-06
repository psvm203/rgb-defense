extends Area2D

var _target: Area2D
var _damage: float
var _color_index: int
var _lifetime: float = 5.0
var _time_since_attack: float = 0.0

const SPEED := 360.0
const ATTACK_RANGE := 64.0
const ATTACK_COOLDOWN := 0.8
const DETECT_RANGE := 300.0


func setup(target: Area2D, damage: float, color_index: int) -> void:
	_target = target
	_damage = damage
	_color_index = color_index


func _process(delta: float) -> void:
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()
		return

	if not is_instance_valid(_target):
		_find_target()
		if not _target:
			queue_free()
			return

	var direction := _target.global_position - global_position
	if direction.length() < ATTACK_RANGE:
		_time_since_attack += delta
		if _time_since_attack >= ATTACK_COOLDOWN:
			_target.take_damage(_color_index, _damage)
			_time_since_attack = 0.0
	else:
		global_position += direction.normalized() * SPEED * delta


func _find_target() -> void:
	var mobs := get_tree().get_nodes_in_group("mobs")
	var closest: Area2D = null
	var closest_dist := DETECT_RANGE
	for mob in mobs:
		if not is_instance_valid(mob) or mob.rgb == Vector3.ZERO:
			continue
		var dist := global_position.distance_to(mob.global_position)
		if dist < closest_dist:
			closest = mob
			closest_dist = dist
	_target = closest


func _draw() -> void:
	draw_circle(Vector2.ZERO, 8.0, Color(0.6, 0.6, 0.9))
