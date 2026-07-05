extends "res://tower/warrior/warrior.gd"

enum State { IDLE, FRENZY, EXHAUSTED }

var _state: State = State.IDLE
var _state_timer: float = 0.0

const NORMAL_COOLDOWN := 1.2
const FRENZY_COOLDOWN := 0.3
const FRENZY_DURATION := 2.0
const EXHAUST_DURATION := 3.0


func _setup_tower() -> void:
	attack_range = 128.0
	attack_cooldown = NORMAL_COOLDOWN
	damage = 0.2
	_color_index = 0
	_tower_color = Color(1.0, 0.2, 0.2)


func _process(delta: float) -> void:
	if _state == State.EXHAUSTED:
		_state_timer -= delta
		if _state_timer <= 0.0:
			_state = State.IDLE
			attack_cooldown = NORMAL_COOLDOWN
		return

	_time_since_attack += delta
	_find_target()
	if _target and _time_since_attack >= attack_cooldown:
		_attack()
		if _state == State.IDLE:
			_state = State.FRENZY
			_state_timer = FRENZY_DURATION
			attack_cooldown = FRENZY_COOLDOWN

	if _state == State.FRENZY:
		_state_timer -= delta
		if _state_timer <= 0.0:
			_state = State.EXHAUSTED
			_state_timer = EXHAUST_DURATION
