extends "res://tower/blue/mage/mage.gd"

var chain_count: int = 5
var chain_radius: float = 200.0

var _lightning_lines: Array = []
var _should_draw_lightning: bool = false


func _setup_tower() -> void:
	attack_range = 200.0
	attack_cooldown = 2.5
	damage = 0.2
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)


func _perform_attack() -> void:
	if not is_instance_valid(_target):
		return
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
		for line in _lightning_lines:
			draw_line(
				line[0] - global_position,
				line[1] - global_position,
				Color.YELLOW,
				3.0,
			)
		_should_draw_lightning = false
