extends "res://tower/blue/electromancer/electromancer.gd"

const CHAIN_COUNT := 9
const CHAIN_RADIUS := 250.0


func _setup_tower() -> void:
	attack_range = 220.0
	attack_cooldown = 2.0
	damage = 0.25
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)
