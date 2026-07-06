extends RefCounted

const LEVEL_0 = preload("res://level/0.gd")
const LEVEL_1 = preload("res://level/1.gd")
const LEVEL_2 = preload("res://level/2.gd")
const LEVEL_3 = preload("res://level/3.gd")
const LEVEL_4 = preload("res://level/4.gd")

const WAVES_BY_LEVEL: Dictionary = {
	0: LEVEL_0.WAVES,
	1: LEVEL_1.WAVES,
	2: LEVEL_2.WAVES,
	3: LEVEL_3.WAVES,
	4: LEVEL_4.WAVES,
}

const STARTING_COINS_BY_LEVEL: Dictionary = {
	0: LEVEL_0.STARTING_COINS,
	1: LEVEL_1.STARTING_COINS,
	2: LEVEL_2.STARTING_COINS,
	3: LEVEL_3.STARTING_COINS,
	4: LEVEL_4.STARTING_COINS,
}

const STARTING_LIVES_BY_LEVEL: Dictionary = {
	0: LEVEL_0.STARTING_LIVES,
	1: LEVEL_1.STARTING_LIVES,
	2: LEVEL_2.STARTING_LIVES,
	3: LEVEL_3.STARTING_LIVES,
	4: LEVEL_4.STARTING_LIVES,
}

const MAX_LEVEL: int = 4


static func get_waves(level: int) -> Array:
	return WAVES_BY_LEVEL.get(level, [])


static func get_wave(level: int, index: int) -> Dictionary:
	var waves := get_waves(level)
	return waves[index % waves.size()]


static func get_starting_coins(level: int) -> int:
	return STARTING_COINS_BY_LEVEL.get(level, 0)


static func get_starting_lives(level: int) -> int:
	return STARTING_LIVES_BY_LEVEL.get(level, 0)
