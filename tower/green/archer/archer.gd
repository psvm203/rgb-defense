extends "res://tower/tower.gd"

func _setup_tower() -> void:
	attack_range = 200.0
	$AnimatedSprite2D.speed_scale = 1.067
	damage = 20
	_color_index = 1
	_tower_color = Color(0.2, 0.9, 0.3)
	_projectile_homing_duration = 0.25
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile()
