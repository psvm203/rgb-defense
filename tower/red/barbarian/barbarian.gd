extends "res://tower/red/warrior/warrior.gd"

enum State { IDLE, FRENZY, EXHAUSTED }

var _state: State = State.IDLE
var _state_timer: float = 0.0

var normal_cooldown: float = 1.2
var frenzy_cooldown: float = 0.3
var frenzy_duration: float = 2.0
var exhaust_duration: float = 3.0


func _setup_tower() -> void:
	attack_range = 128.0
	attack_cooldown = normal_cooldown
	damage = 0.2
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _process(delta: float) -> void:
	if _state == State.EXHAUSTED:
		_state_timer -= delta
		if _state_timer <= 0.0:
			_state = State.IDLE
			attack_cooldown = normal_cooldown
		return

	_time_since_attack += delta
	_find_target()
	if _target and _time_since_attack >= attack_cooldown:
		_attack()
		if _state == State.IDLE:
			_state = State.FRENZY
			_state_timer = frenzy_duration
			attack_cooldown = frenzy_cooldown

	if _state == State.FRENZY:
		_state_timer -= delta
		if _state_timer <= 0.0:
			_state = State.EXHAUSTED
			_state_timer = exhaust_duration
