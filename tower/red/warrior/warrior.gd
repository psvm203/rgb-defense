extends "res://tower/tower.gd"

func _setup_tower() -> void:
	attack_range = 128.0
	$AnimatedSprite2D.speed_scale = 1.5
	damage = 30
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _perform_attack() -> void:
	SfxPlayer.play("sword")
	_target.take_damage(0, damage)
