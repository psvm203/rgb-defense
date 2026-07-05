extends "res://tower/red/brawler/brawler.gd"

const KNOCKBACK_INTERVAL := 2
const KNOCKBACK_DISTANCE := 96.0


func _setup_tower() -> void:
	attack_range = 128.0
	attack_cooldown = 0.8
	damage = 0.3
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
