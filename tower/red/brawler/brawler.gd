extends "res://tower/red/warrior/warrior.gd"

var _attack_count: int = 0

var knockback_interval: int = 3
var knockback_distance: float = 64.0


func _setup_tower() -> void:
	attack_range = 128.0
	attack_cooldown = 1.0
	damage = 0.25
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _perform_attack() -> void:
	_attack_count += 1
	_target.take_damage(0, damage)
	if _attack_count >= knockback_interval:
		_target.knock_back(knockback_distance)
		_attack_count = 0
