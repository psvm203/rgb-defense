extends Area2D

@export var speed: float = 120.0


func _process(delta: float) -> void:
	var path_follow := get_parent() as PathFollow2D
	if path_follow:
		path_follow.progress += speed * delta


func _draw() -> void:
	draw_circle(Vector2.ZERO, 16.0, Color(0.8, 0.2, 0.2))
