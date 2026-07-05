extends "res://tower/green/stormbringer/stormbringer.gd"

func _setup_tower() -> void:
	attack_range = 220.0
	attack_cooldown = 1.5
	damage = 0.18
	_color_index = 1
	_tower_color = Color(0.2, 1.0, 0.2)
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile()

	var direction := (_target.global_position - global_position).normalized()
	var perp := Vector2(-direction.y, direction.x)

	for side in [-2, -1, 0, 1, 2]:
		var offset: Vector2 = perp * 20 * side
		var projectile := _projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position + offset
		projectile.setup(_target, damage, _color_index, _projectile_color)
