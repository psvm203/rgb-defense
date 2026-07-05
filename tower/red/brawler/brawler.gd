extends "res://tower/red/warrior/warrior.gd"

var _attack_count: int = 0

var knockback_interval: int = 3
var knockback_distance: float = 64.0


func _setup_tower() -> void:
	attack_range = 128.0
	$AnimatedSprite2D.speed_scale = 1.0
	damage = 0.25
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _attack() -> void:
	if not is_instance_valid(_target):
		_target = null
		return
	_target_locked = true
	var is_flipped := _target.global_position.x < global_position.x
	$AnimatedSprite2D.flip_h = is_flipped
	$AnimatedSprite2D.position.x = -_base_sprite_x if is_flipped else _base_sprite_x
	if _attack_count + 1 >= knockback_interval:
		_attack_frame = 5
		$AnimatedSprite2D.play("knockback")
	else:
		_attack_frame = 3
		$AnimatedSprite2D.play("attack")


func _perform_attack() -> void:
	_attack_count += 1
	_target.take_damage(0, damage)
	if _attack_count >= knockback_interval:
		_target.knock_back(knockback_distance)
		_attack_count = 0
