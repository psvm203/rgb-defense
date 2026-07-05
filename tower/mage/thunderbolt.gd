extends "res://tower/mage/mage.gd"

func _setup_tower() -> void:
	attack_range = 200.0
	attack_cooldown = 2.5
	damage = 0.2
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 0, 0.0, 1.0, 5, 200.0)
