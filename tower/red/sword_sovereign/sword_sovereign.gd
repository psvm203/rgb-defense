extends "res://tower/red/sword_saint/sword_saint.gd"

func _setup_tower() -> void:
	attack_range = 300.0
	attack_cooldown = 1.2
	damage = 0.4
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
	_attack_frame = 3


func _perform_attack() -> void:
	_spawn_projectile(0.0, 2)
