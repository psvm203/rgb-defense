extends "res://tower/tower.gd"

@export var attack_range: float = 180.0
@export var attack_cooldown: float = 2.0
@export var damage: float = 0.15
@export var splash_radius: float = 80.0


func _setup_tower() -> void:
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)
	_attack_frame = 6


func _perform_attack() -> void:
	_spawn_projectile(splash_radius)
