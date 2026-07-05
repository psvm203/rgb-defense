extends "res://tower/red/brawler/brawler.gd"

func _setup_tower() -> void:
	knockback_interval = 2
	knockback_distance = 96.0
	attack_range = 128.0
	$AnimatedSprite2D.speed_scale = 1.25
	damage = 0.3
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
