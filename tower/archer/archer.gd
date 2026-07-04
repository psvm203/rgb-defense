extends "res://tower/tower.gd"

@export var attack_range: float = 200.0
@export var attack_cooldown: float = 1.5
@export var damage: float = 0.2


func _setup_tower() -> void:
	_color_index = 1
	_tower_color = Color(0.2, 1.0, 0.2)
	_projectile_color = Color(0.2, 1.0, 0.2)


func _perform_attack() -> void:
	_spawn_projectile()
