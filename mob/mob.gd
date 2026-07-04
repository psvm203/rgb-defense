extends Area2D

@export var speed: float = 128.0
@export var max_rgb: Vector3 = Vector3(0.0, 0.0, 1.0)

var rgb: Vector3
var _base_sprite_x: float


func _ready() -> void:
	rgb = max_rgb
	_update_appearance()
	_base_sprite_x = $AnimatedSprite2D.position.x
	add_to_group("mobs")
	GameState.mob_spawned()


func _process(delta: float) -> void:
	var path_follow := get_parent() as PathFollow2D
	if not path_follow:
		return
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 1.0:
		GameState.lose_life()
		GameState.mob_destroyed()
		queue_free()
		return
	_update_flip(path_follow)


func _update_flip(path_follow: PathFollow2D) -> void:
	var path := path_follow.get_parent() as Path2D
	if not path or not path.curve:
		return
	var curve := path.curve
	var baked_length := curve.get_baked_length()
	if baked_length < 1.0:
		return
	var progress := path_follow.progress
	var pos1 := curve.sample_baked(progress)
	var pos2 := curve.sample_baked(minf(progress + 10.0, baked_length))
	var tangent := pos2 - pos1
	if abs(tangent.x) > 1.0:
		var is_flipped := tangent.x < 0.0
		$AnimatedSprite2D.flip_h = is_flipped
		$AnimatedSprite2D.position.x = -_base_sprite_x if is_flipped else _base_sprite_x


func _update_appearance() -> void:
	var color := Color(
		_channel_color(rgb.x, max_rgb.x),
		_channel_color(rgb.y, max_rgb.y),
		_channel_color(rgb.z, max_rgb.z),
	)
	$AnimatedSprite2D.self_modulate = color
	queue_redraw()


func _channel_color(value: float, max_value: float) -> float:
	if value <= 0.0 or max_value <= 0.0:
		return 0.0
	return maxf(value / max_value, 0.4)


func take_damage(color_index: int, amount: float) -> void:
	rgb[color_index] = maxf(0.0, rgb[color_index] - amount)
	_update_appearance()
	if rgb == Vector3.ZERO:
		GameState.mob_destroyed()
		queue_free()


func _draw() -> void:
	const BAR_WIDTH := 40.0
	const BAR_HEIGHT := 4.0
	const BAR_Y := -32.0

	var total_max := max_rgb.x + max_rgb.y + max_rgb.z
	var total_current := rgb.x + rgb.y + rgb.z
	if total_max <= 0.0:
		return

	var ratio := total_current / total_max
	var bar_color := Color(
		1.0 if rgb.x > 0.0 else 0.0,
		1.0 if rgb.y > 0.0 else 0.0,
		1.0 if rgb.z > 0.0 else 0.0,
	)

	draw_rect(Rect2(-BAR_WIDTH / 2.0, BAR_Y, BAR_WIDTH, BAR_HEIGHT), Color.BLACK)
	draw_rect(Rect2(-BAR_WIDTH / 2.0, BAR_Y, BAR_WIDTH * ratio, BAR_HEIGHT), bar_color)
	draw_rect(
		Rect2(-BAR_WIDTH / 2.0, BAR_Y, BAR_WIDTH, BAR_HEIGHT),
		Color(1.0, 1.0, 1.0, 0.5),
		false,
		1.0,
	)
