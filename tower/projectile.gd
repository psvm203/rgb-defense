extends Area2D

@export var speed: float = 300.0

var _damage: float
var _color_index: int
var _color: Color
var _texture: Texture2D
var _texture_scale: float = 1.0
var _target: Area2D
var _acceleration: float = 0.0
var _homing_duration: float = 0.0
var _homing_timer: float = 0.0
var _afterimage_interval: float = 0.0
var _afterimage_timer: float = 0.0
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
	_hit_direction = (target.global_position - global_position).normalized()


func _process(delta: float) -> void:
	speed += _acceleration * delta
	_homing_timer += delta
	if _homing_timer < _homing_duration and is_instance_valid(_target):
		var dir := _target.global_position - global_position
		if dir.length() > 0.0:
			var target_dir := dir.normalized()
			var angle := _hit_direction.angle_to(target_dir)
			var max_rot := 8.0 * delta
			_hit_direction = _hit_direction.rotated(clampf(angle, -max_rot, max_rot))
	var step := _hit_direction * speed * delta
	global_position += step
	_travel_distance += step.length()
	if _travel_distance > MAX_TRAVEL:
		queue_free()
		return

	_spawn_afterimage_trail(delta)

	var mobs := get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		if not is_instance_valid(mob) or _hit_targets.has(mob):
			continue
		if global_position.distance_to(mob.global_position) < 24.0:
			_on_hit(mob)
			return


func _on_hit(mob: Area2D) -> void:
	_hit_targets.append(mob)
	_homing_timer = _homing_duration
	_apply_damage(mob)
	if _splash_radius > 0.0:
		_apply_splash()
	if _chain_count > 0:
		_apply_chain(mob.global_position)
	if _pierce_count > 0:
		_pierce_count -= 1
	else:
		queue_free()


func _apply_damage(mob: Area2D) -> void:
	mob.take_damage(_color_index, _damage)
	if _slow_duration > 0.0:
		mob.apply_slow(_slow_duration, _slow_factor)


func _apply_splash() -> void:
	var mobs := get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		if not is_instance_valid(mob) or _hit_targets.has(mob):
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


func set_texture(texture: Texture2D) -> void:
	_texture = texture
	queue_redraw()


func set_texture_scale(scale: float) -> void:
	_texture_scale = scale
	queue_redraw()


func set_homing_duration(duration: float) -> void:
	_homing_duration = duration


func set_acceleration(accel: float) -> void:
	_acceleration = accel


func set_afterimage(interval: float) -> void:
	_afterimage_interval = interval


func _draw() -> void:
	if _texture:
		var angle := atan2(_hit_direction.y, _hit_direction.x)
		draw_set_transform(Vector2.ZERO, angle, Vector2(_texture_scale, _texture_scale))
		draw_texture(_texture, -_texture.get_size() / 2.0)
	else:
		draw_circle(Vector2.ZERO, 4.0, _color)


func _spawn_afterimage_trail(delta: float) -> void:
	if _afterimage_interval <= 0.0 or not _texture:
		return
	_afterimage_timer += delta
	if _afterimage_timer < _afterimage_interval:
		return
	_afterimage_timer = 0.0
	var parent := get_tree().current_scene
	if not parent:
		return
	var img := Sprite2D.new()
	img.texture = _texture
	img.scale = Vector2(_texture_scale, _texture_scale)
	img.rotation = atan2(_hit_direction.y, _hit_direction.x)
	img.global_position = global_position
	img.modulate = Color(1, 1, 1, 1)
	img.z_index = 10
	parent.add_child(img)
	var tween := img.create_tween()
	tween.tween_property(img, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_IN)
	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	img.add_child(timer)
	timer.timeout.connect(img.queue_free)
	timer.start()
