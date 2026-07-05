extends "res://tower/tower.gd"

func _setup_tower() -> void:
	attack_range = 128.0
	attack_cooldown = 1.0
	damage = 0.3
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _perform_attack() -> void:
	_target.take_damage(0, damage)
