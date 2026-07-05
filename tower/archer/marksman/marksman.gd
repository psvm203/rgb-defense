extends "res://tower/archer/archer.gd"

func _setup_tower() -> void:
	attack_range = 250.0
	attack_cooldown = 1.8
	damage = 0.2
	_color_index = 1
	_tower_color = Color(0.2, 1.0, 0.2)
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 3)
