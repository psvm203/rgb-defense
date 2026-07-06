extends "res://tower/green/archer/archer.gd"

func _setup_tower() -> void:
	attack_range = 200.0
	$AnimatedSprite2D.speed_scale = 0.6
	damage = 15
	_color_index = 1
	_tower_color = Color(0.2, 0.9, 0.3)
	_projectile_homing_duration = 0.25
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile()

	var direction := (_target.global_position - global_position).normalized()
	var perp := Vector2(-direction.y, direction.x)

	for side in [-1, 1]:
		var projectile := _projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position + perp * 20 * side
		projectile.setup(_target, damage, _color_index, _projectile_color)
