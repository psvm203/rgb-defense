extends Area2D

signal died

@export var speed: float = 128.0
@export var max_rgb: Vector3 = Vector3(0.0, 0.0, 1.0)

var rgb: Vector3
var _base_sprite_x: float
var _traveled: float = 0.0
var _base_speed: float
var _slow_timer: float = 0.0
var _knockback_tween: Tween


func get_traveled() -> float:
	return _traveled


func knock_back(distance: float) -> void:
	var target := maxf(0.0, _traveled - distance)
	if _knockback_tween:
		_knockback_tween.kill()
	_knockback_tween = create_tween()
	_knockback_tween.tween_property(
		self,
		"_traveled",
		target,
		0.15,
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func apply_slow(duration: float, factor: float) -> void:
	speed = _base_speed * factor
	_slow_timer = duration


func _ready() -> void:
	rgb = max_rgb
	_base_speed = speed
	_update_appearance()
	_base_sprite_x = $AnimatedSprite2D.position.x
	add_to_group("mobs")
	var path := get_parent() as Path2D
	if path and path.curve:
		position = path.curve.sample_baked(0.0)


func _process(delta: float) -> void:
	if _slow_timer > 0.0:
		_slow_timer -= delta
		if _slow_timer <= 0.0:
			speed = _base_speed

	var path := get_parent() as Path2D
	if not path or not path.curve:
		return
	var curve := path.curve
	var baked_length := curve.get_baked_length()
	if not _knockback_tween or not _knockback_tween.is_running():
		_traveled += speed * delta
	position = curve.sample_baked(_traveled)
	if _traveled >= baked_length:
		GameState.lose_life()
		SfxPlayer.play("damage")
		died.emit()
		queue_free()
		return
	_update_flip(curve, baked_length)


func _update_flip(curve: Curve2D, baked_length: float) -> void:
	var pos1 := curve.sample_baked(_traveled)
	var pos2 := curve.sample_baked(minf(_traveled + 10.0, baked_length))
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
	var splash_amount := amount / 3.0
	for i in range(3):
		if i != color_index and rgb[i] > 0.0:
			rgb[i] = maxf(0.0, rgb[i] - splash_amount)
	_update_appearance()
	if rgb == Vector3.ZERO:
		GameState.add_coins(int(max_rgb.x + max_rgb.y + max_rgb.z))
		died.emit()
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
