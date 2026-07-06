extends "res://tower/red/sword_saint/sword_saint.gd"

func _setup_tower() -> void:
	attack_range = 300.0
	$AnimatedSprite2D.speed_scale = 0.648
	damage = 40
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
	_attack_frame = 3
	_projectile_speed = 500.0
	_projectile_texture = preload("res://tower/red/sword_sovereign/sword_aura.png")
	_projectile_scale = 2.0
	_projectile_homing_duration = 0.25
	_projectile_acceleration = 400.0
	_projectile_afterimage_interval = 0.05


func _perform_attack() -> void:
	_spawn_projectile(0.0, 2)
