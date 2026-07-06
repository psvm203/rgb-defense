extends RefCounted

const LEVEL_0 = preload("res://level/0.gd")
const LEVEL_1 = preload("res://level/1.gd")
const LEVEL_2 = preload("res://level/2.gd")
const LEVEL_3 = preload("res://level/3.gd")
const LEVEL_4 = preload("res://level/4.gd")
const LEVEL_5 = preload("res://level/5.gd")
const LEVEL_6 = preload("res://level/6.gd")
const LEVEL_7 = preload("res://level/7.gd")
const LEVEL_8 = preload("res://level/8.gd")
const LEVEL_9 = preload("res://level/9.gd")
const LEVEL_10 = preload("res://level/10.gd")

const WAVES_BY_LEVEL: Dictionary = {
	0: LEVEL_0.WAVES,
	1: LEVEL_1.WAVES,
	2: LEVEL_2.WAVES,
	3: LEVEL_3.WAVES,
	4: LEVEL_4.WAVES,
	5: LEVEL_5.WAVES,
	6: LEVEL_6.WAVES,
	7: LEVEL_7.WAVES,
	8: LEVEL_8.WAVES,
	9: LEVEL_9.WAVES,
	10: LEVEL_10.WAVES,
}

const STARTING_COINS_BY_LEVEL: Dictionary = {
	0: LEVEL_0.STARTING_COINS,
	1: LEVEL_1.STARTING_COINS,
	2: LEVEL_2.STARTING_COINS,
	3: LEVEL_3.STARTING_COINS,
	4: LEVEL_4.STARTING_COINS,
	5: LEVEL_5.STARTING_COINS,
	6: LEVEL_6.STARTING_COINS,
	7: LEVEL_7.STARTING_COINS,
	8: LEVEL_8.STARTING_COINS,
	9: LEVEL_9.STARTING_COINS,
	10: LEVEL_10.STARTING_COINS,
}

const STARTING_LIVES_BY_LEVEL: Dictionary = {
	0: LEVEL_0.STARTING_LIVES,
	1: LEVEL_1.STARTING_LIVES,
	2: LEVEL_2.STARTING_LIVES,
	3: LEVEL_3.STARTING_LIVES,
	4: LEVEL_4.STARTING_LIVES,
	5: LEVEL_5.STARTING_LIVES,
	6: LEVEL_6.STARTING_LIVES,
	7: LEVEL_7.STARTING_LIVES,
	8: LEVEL_8.STARTING_LIVES,
	9: LEVEL_9.STARTING_LIVES,
	10: LEVEL_10.STARTING_LIVES,
}

const MAX_LEVEL: int = 10


static func get_waves(level: int) -> Array:
	return WAVES_BY_LEVEL.get(level, [])


static func get_wave(level: int, index: int) -> Dictionary:
	var waves := get_waves(level)
	return waves[index % waves.size()]


static func get_starting_coins(level: int) -> int:
	return STARTING_COINS_BY_LEVEL.get(level, 0)


static func get_starting_lives(level: int) -> int:
	return STARTING_LIVES_BY_LEVEL.get(level, 0)
