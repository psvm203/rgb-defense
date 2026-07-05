extends "res://tower/blue/electromancer/electromancer.gd"

func _setup_tower() -> void:
	chain_count = 9
	chain_radius = 250.0
	attack_range = 220.0
	attack_cooldown = 2.0
	damage = 0.25
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)
