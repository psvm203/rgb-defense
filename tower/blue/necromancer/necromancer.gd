extends "res://tower/blue/mage/mage.gd"

var _skeleton_scene: PackedScene


func _setup_tower() -> void:
	_skeleton_scene = preload("res://tower/blue/skeleton/skeleton.tscn")
	attack_range = 180.0
	$AnimatedSprite2D.speed_scale = 0.3125
	damage = 0.3
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)


func _perform_attack() -> void:
	SfxPlayer.play("summon")
	var skeleton := _skeleton_scene.instantiate()
	get_parent().add_child(skeleton)
	skeleton.global_position = global_position
	skeleton.setup(_target, damage, _color_index)
