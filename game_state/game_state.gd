extends Node

@warning_ignore("unused_signal")
signal game_over

const LEVEL_WAVES: Dictionary = {
	0: [
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 2 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 2 },
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 2 },
			],
			interval = 1.5,
		},
	],
	1: [
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 3 },
			],
			interval = 1.5,
		},
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 5 },
			],
			interval = 1.2,
		},
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 7 },
			],
			interval = 1.0,
		},
	],
	2: [
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 5 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 3 },
			],
			interval = 1.2,
		},
		{
			groups = [
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 4 },
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 2 },
			],
			interval = 1.0,
		},
		{
			groups = [
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 4 },
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 4 },
			],
			interval = 1.0,
		},
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 3 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 3 },
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 3 },
			],
			interval = 1.0,
		},
	],
	3: [
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 6 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 4 },
			],
			interval = 1.2,
		},
		{
			groups = [
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 5 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 5 },
			],
			interval = 1.0,
		},
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 4 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 4 },
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 4 },
			],
			interval = 1.0,
		},
		{
			groups = [
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 6 },
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 4 },
			],
			interval = 0.9,
		},
		{
			groups = [
				{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 5 },
				{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 5 },
				{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 5 },
			],
			interval = 0.8,
		},
	],
}
const MAX_LEVEL := 3

const PROGRESS_PATH := "user://progress.cfg"
const PROGRESS_SECTION := "progress"

var lives: int = 10
var coins: int = 10000
var current_level: int = 1


func get_waves(level: int) -> Array:
	return LEVEL_WAVES.get(level, [])


func get_wave(level: int, index: int) -> Dictionary:
	var waves := get_waves(level)
	return waves[index % waves.size()]


func is_level_unlocked(level: int) -> bool:
	if level <= 1:
		return true
	var config := ConfigFile.new()
	if config.load(PROGRESS_PATH) != OK:
		return false
	return config.get_value(PROGRESS_SECTION, "unlocked", 1) >= level


func unlock_next_level() -> void:
	var config := ConfigFile.new()
	config.load(PROGRESS_PATH)
	var unlocked := maxi(config.get_value(PROGRESS_SECTION, "unlocked", 1), current_level + 1)
	config.set_value(PROGRESS_SECTION, "unlocked", unlocked)
	config.save(PROGRESS_PATH)


func spend_coins(amount: int) -> bool:
	if coins < amount:
		return false
	coins -= amount
	return true


func add_coins(amount: int) -> void:
	coins += amount


func lose_life() -> void:
	if lives <= 0:
		return
	lives -= 1
	if lives <= 0:
		game_over.emit()
