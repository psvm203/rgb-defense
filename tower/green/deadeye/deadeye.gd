extends "res://tower/green/sniper/sniper.gd"

func _setup_tower() -> void:
	attack_range = 350.0
	$AnimatedSprite2D.speed_scale = 0.8
	damage = 30
	_color_index = 1
	_tower_color = Color(0.2, 0.9, 0.3)
	_projectile_homing_duration = 0.25
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 99)
