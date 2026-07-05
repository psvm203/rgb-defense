extends "res://tower/green/viper/viper.gd"

func _setup_tower() -> void:
	attack_range = 220.0
	$AnimatedSprite2D.speed_scale = 0.667
	damage = 0.18
	_color_index = 1
	_tower_color = Color(0.2, 1.0, 0.2)
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 0, 4.0, 0.3)
