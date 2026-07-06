extends "res://tower/red/warrior/warrior.gd"

enum State { IDLE, FRENZY, EXHAUSTED }

var _state: State = State.IDLE
var _state_timer: float = 0.0

var normal_speed_scale: float = 0.278
var frenzy_speed_scale: float = 1.111
var frenzy_duration: float = 4.0
var exhaust_duration: float = 2.0


func _setup_tower() -> void:
	attack_range = 128.0
	$AnimatedSprite2D.speed_scale = normal_speed_scale
	damage = 20
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _process(delta: float) -> void:
	if _state == State.EXHAUSTED:
		_state_timer -= delta
		if _state_timer <= 0.0:
			_state = State.IDLE
			$AnimatedSprite2D.speed_scale = normal_speed_scale
		return

	_find_target()
	if _target and $AnimatedSprite2D.animation == "default":
		_attack()
		if _state == State.IDLE:
			_state = State.FRENZY
			_state_timer = frenzy_duration
			$AnimatedSprite2D.speed_scale = frenzy_speed_scale

	if _state == State.FRENZY:
		_state_timer -= delta
		if _state_timer <= 0.0:
			_state = State.EXHAUSTED
			_state_timer = exhaust_duration
			$AnimatedSprite2D.speed_scale = normal_speed_scale
