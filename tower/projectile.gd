extends Area2D

@export var speed: float = 300.0

var _target: Area2D
var _damage: float
var _color_index: int
var _color: Color


func setup(target: Area2D, damage: float, color_index: int, proj_color: Color) -> void:
	_target = target
	_damage = damage
	_color_index = color_index
	_color = proj_color


func _process(delta: float) -> void:
	if not is_instance_valid(_target):
		queue_free()
		return

	var direction := _target.global_position - global_position
	if direction.length() < 8.0:
		_target.take_damage(_color_index, _damage)
		queue_free()
		return

	global_position += direction.normalized() * speed * delta


func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, _color)
