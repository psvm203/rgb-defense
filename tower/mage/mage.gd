extends "res://tower/tower.gd"

@export var splash_radius: float = 80.0


func _setup_tower() -> void:
	attack_range = 180.0
	attack_cooldown = 2.0
	damage = 0.15
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)
	_attack_frame = 6


func _perform_attack() -> void:
	_spawn_projectile(splash_radius)
