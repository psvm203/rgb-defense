extends Area2D

@export var speed: float = 300.0

var _target: Area2D
var _damage: float
var _color_index: int
var _color: Color
var _splash_radius: float = 0.0
var _pierce_count: int = 0
var _hit_direction: Vector2
var _travel_distance: float = 0.0
var _slow_duration: float = 0.0
var _slow_factor: float = 1.0
var _chain_count: int = 0
var _chain_radius: float = 0.0
var _hit_targets: Array[Area2D] = []
const MAX_TRAVEL := 500.0


func setup(
		target: Area2D,
		damage: float,
		color_index: int,
		proj_color: Color,
		splash_radius: float = 0.0,
		pierce_count: int = 0,
		slow_duration: float = 0.0,
		slow_factor: float = 1.0,
		chain_count: int = 0,
		chain_radius: float = 0.0,
) -> void:
	_target = target
	_damage = damage
	_color_index = color_index
	_color = proj_color
	_splash_radius = splash_radius
	_pierce_count = pierce_count
	_slow_duration = slow_duration
	_slow_factor = slow_factor
	_chain_count = chain_count
	_chain_radius = chain_radius


func _process(delta: float) -> void:
	if _pierce_count > 0 and not is_instance_valid(_target):
		var step := _hit_direction * speed * delta
		global_position += step
		_travel_distance += step.length()
		if _travel_distance > MAX_TRAVEL:
			queue_free()
			return
		_check_pierce()
		return

	if not is_instance_valid(_target):
		queue_free()
		return

	var direction := _target.global_position - global_position
	if direction.length() < 8.0:
		if _splash_radius > 0.0:
			_apply_splash()
		else:
			_hit_targets.append(_target)
			_apply_damage(_target)
			if _chain_count > 0:
				_apply_chain(_target.global_position)
		if _pierce_count > 0:
			_hit_direction = direction.normalized()
			_pierce_count -= 1
			_target = null
		else:
			queue_free()
		return

	global_position += direction.normalized() * speed * delta


func _apply_damage(mob: Area2D) -> void:
	mob.take_damage(_color_index, _damage)
	if _slow_duration > 0.0:
		mob.apply_slow(_slow_duration, _slow_factor)


func _check_pierce() -> void:
	var mobs := get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		if not is_instance_valid(mob):
			continue
		if global_position.distance_to(mob.global_position) < 24.0:
			_apply_damage(mob)
			_pierce_count -= 1
			if _pierce_count <= 0:
				queue_free()
			return


func _apply_splash() -> void:
	var mobs := get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		if not is_instance_valid(mob):
			continue
		var dist := global_position.distance_to(mob.global_position)
		if dist <= _splash_radius:
			_apply_damage(mob)


func _apply_chain(from_pos: Vector2) -> void:
	for i in range(_chain_count):
		var mobs := get_tree().get_nodes_in_group("mobs")
		var closest: Area2D = null
		var closest_dist := _chain_radius
		for mob in mobs:
			if not is_instance_valid(mob) or _hit_targets.has(mob):
				continue
			var dist := from_pos.distance_to(mob.global_position)
			if dist < closest_dist:
				closest = mob
				closest_dist = dist
		if not closest:
			break
		_hit_targets.append(closest)
		_apply_damage(closest)
		from_pos = closest.global_position


func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, _color)
