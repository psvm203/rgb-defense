extends "res://tower/green/marksman/marksman.gd"

func _setup_tower() -> void:
	attack_range = 350.0
	attack_cooldown = 1.5
	damage = 0.3
	_color_index = 1
	_tower_color = Color(0.2, 1.0, 0.2)
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 99)
