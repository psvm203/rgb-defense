extends "res://tower/red/barbarian/barbarian.gd"

func _setup_tower() -> void:
	normal_speed_scale = 0.333
	frenzy_speed_scale = 2.222
	frenzy_duration = 5.0
	exhaust_duration = 1.5
	attack_range = 128.0
	$AnimatedSprite2D.speed_scale = normal_speed_scale
	damage = 25
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
