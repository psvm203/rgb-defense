extends "res://tower/red/barbarian/barbarian.gd"

func _setup_tower() -> void:
	normal_cooldown = 1.0
	frenzy_cooldown = 0.15
	frenzy_duration = 3.0
	exhaust_duration = 2.0
	attack_range = 128.0
	attack_cooldown = normal_cooldown
	damage = 0.25
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
