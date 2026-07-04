extends "res://tower/tower.gd"

@export var attack_range: float = 128.0
@export var attack_cooldown: float = 1.0
@export var damage: float = 0.3


func _setup_tower() -> void:
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _perform_attack() -> void:
	_target.take_damage(0, damage)
