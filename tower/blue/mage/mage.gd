extends "res://tower/tower.gd"

@export var splash_radius: float = 80.0


func _setup_tower() -> void:
	attack_range = 180.0
	$AnimatedSprite2D.speed_scale = 0.5
	damage = 15
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)
	_attack_frame = 6


func _perform_attack() -> void:
	SfxPlayer.play("magic")
	_spawn_projectile(splash_radius)
