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

const MAX_LEVEL: int = 4


static func get_waves(level: int) -> Array:
	return WAVES_BY_LEVEL.get(level, [])


static func get_wave(level: int, index: int) -> Dictionary:
	var waves := get_waves(level)
	return waves[index % waves.size()]
