extends "res://tower/mage/mage.gd"

var _skeleton_scene: PackedScene


func _setup_tower() -> void:
	_skeleton_scene = preload("res://tower/mage/skeleton.tscn")
	attack_range = 180.0
	attack_cooldown = 4.0
	damage = 0.3
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)


func _perform_attack() -> void:
	var skeleton := _skeleton_scene.instantiate()
	get_parent().add_child(skeleton)
	skeleton.global_position = global_position
	skeleton.setup(_target, damage, _color_index)
