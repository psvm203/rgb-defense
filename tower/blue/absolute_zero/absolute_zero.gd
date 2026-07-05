extends "res://tower/blue/frost_mage/frost_mage.gd"

func _setup_tower() -> void:
	attack_range = 200.0
	attack_cooldown = 2.0
	damage = 0.15
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.5, 0.5, 1.0)


func _perform_attack() -> void:
	_spawn_projectile(0.0, 0, 3.0, 0.0)
