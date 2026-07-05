extends "res://tower/green/archer/archer.gd"

func _setup_tower() -> void:
	attack_range = 200.0
	attack_cooldown = 2.0
	damage = 0.15
	_color_index = 1
	_tower_color = Color(0.2, 1.0, 0.2)
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 0, 3.0, 0.5)
