extends Node

@warning_ignore("unused_signal")
signal game_over

const PROGRESS_PATH := "user://progress.cfg"
const PROGRESS_SECTION := "progress"

var lives: int = 10
var coins: int = 10000
var current_level: int = 1


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
