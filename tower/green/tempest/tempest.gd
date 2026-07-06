extends "res://tower/green/hunter/hunter.gd"

func _setup_tower() -> void:
	attack_range = 220.0
	$AnimatedSprite2D.speed_scale = 0.8
	damage = 18
	_color_index = 1
	_tower_color = Color(0.2, 0.9, 0.3)
	_projectile_homing_duration = 0.25
	_projectile_texture = preload("res://tower/green/archer/arrow.png")
	_projectile_speed = 600.0
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
		projectile.set_texture(_projectile_texture)
		projectile.setup(_target, damage, _color_index, _projectile_color)
