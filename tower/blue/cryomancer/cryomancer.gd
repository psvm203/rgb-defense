extends "res://tower/blue/mage/mage.gd"

func _setup_tower() -> void:
	attack_range = 180.0
	$AnimatedSprite2D.speed_scale = 0.5
	damage = 10
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_homing_duration = 0.25
	_projectile_color = Color(0.5, 0.5, 1.0)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 0, 2.0, 0.0)
