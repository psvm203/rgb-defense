extends "res://tower/red/barbarian/barbarian.gd"

const NORMAL_COOLDOWN := 1.0
const FRENZY_COOLDOWN := 0.15
const FRENZY_DURATION := 3.0
const EXHAUST_DURATION := 2.0


func _setup_tower() -> void:
	attack_range = 128.0
	attack_cooldown = NORMAL_COOLDOWN
	damage = 0.25
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)
