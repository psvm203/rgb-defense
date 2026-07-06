extends "res://tower/blue/necromancer/necromancer.gd"

func _setup_tower() -> void:
	_skeleton_scene = preload("res://tower/blue/skeleton/skeleton.tscn")
	attack_range = 200.0
	$AnimatedSprite2D.speed_scale = 0.357
	damage = 35
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)


func _perform_attack() -> void:
	for i in range(2):
		var skeleton := _skeleton_scene.instantiate()
		get_parent().add_child(skeleton)
		skeleton.global_position = global_position
		skeleton.setup(_target, damage, _color_index)
