extends "res://tower/red/warrior/warrior.gd"

func _setup_tower() -> void:
	attack_range = 200.0
	$AnimatedSprite2D.speed_scale = 0.333
	damage = 30
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
	_attack_frame = 3
	_projectile_texture = preload("res://tower/red/sword_saint/sword_aura.png")
	_projectile_homing_duration = 0.25


func _perform_attack() -> void:
	SfxPlayer.play("sword_aura")
	_spawn_projectile()
