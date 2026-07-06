extends "res://tower/blue/mage/mage.gd"

var chain_count: int = 5
var chain_radius: float = 200.0

var _lightning_lines: Array = []
var _should_draw_lightning: bool = false
var _lightning_texture: Texture2D
var _lightning_frame: int = 0
var _lightning_timer: Timer
const LIGHTNING_FRAME_COUNT := 7
const LIGHTNING_FRAME_W := 64


func _setup_tower() -> void:
	attack_range = 200.0
	$AnimatedSprite2D.speed_scale = 0.5
	damage = 20
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)

	_lightning_texture = preload("res://tower/blue/electromancer/lightning.png")
	_lightning_timer = Timer.new()
	_lightning_timer.one_shot = true
	_lightning_timer.timeout.connect(_on_lightning_frame)
	add_child(_lightning_timer)


func _perform_attack() -> void:
	if not is_instance_valid(_target):
		return
	SfxPlayer.play("thunder")
	_target.take_damage(_color_index, damage)
	_lightning_lines.clear()
	_lightning_lines.append([global_position, _target.global_position])
	var from := _target.global_position
	var hit_targets: Array[Area2D] = [_target]
	for i in range(chain_count):
		var closest := _find_chain_mob(from, hit_targets, chain_radius)
		if not closest:
			break
		closest.take_damage(_color_index, damage)
		hit_targets.append(closest)
		_lightning_lines.append([from, closest.global_position])
		from = closest.global_position
	_should_draw_lightning = true
	_lightning_frame = 0
	_lightning_timer.start(0.05)
	queue_redraw()


func _find_chain_mob(from: Vector2, exclude: Array, radius: float) -> Area2D:
	var mobs := get_tree().get_nodes_in_group("mobs")
	var closest: Area2D = null
	var closest_dist := radius
	for mob in mobs:
		if not is_instance_valid(mob) or exclude.has(mob):
			continue
		var dist := from.distance_to(mob.global_position)
		if dist < closest_dist:
			closest = mob
			closest_dist = dist
	return closest


func _draw() -> void:
	super._draw()
	if _should_draw_lightning:
		var src_rect := Rect2(
			_lightning_frame * LIGHTNING_FRAME_W,
			0,
			LIGHTNING_FRAME_W,
			64,
		)
		for line in _lightning_lines:
			var from: Vector2 = line[0] - global_position
			var to: Vector2 = line[1] - global_position
			var dir := to - from
			var length := dir.length()
			if length <= 0.0:
				continue
			var angle := dir.angle()
			var center := (from + to) / 2.0
			var dst_rect := Rect2(-length / 2.0, -32.0, length, 64)
			draw_set_transform(center, angle)
			draw_texture_rect_region(_lightning_texture, dst_rect, src_rect)
			draw_set_transform(Vector2.ZERO, 0.0)


func _on_lightning_frame() -> void:
	_lightning_frame += 1
	if _lightning_frame < LIGHTNING_FRAME_COUNT:
		_lightning_timer.start(0.05)
		queue_redraw()
	else:
		_lightning_frame = 0
		_should_draw_lightning = false
		queue_redraw()
