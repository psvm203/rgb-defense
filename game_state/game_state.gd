extends Node

signal wave_completed
signal start_wave_pressed

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 3 },
		],
		interval = 1.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 3 },
			{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 2 },
		],
		interval = 1.2,
	},
	{
		groups = [
			{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 4 },
			{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 3 },
			{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 1 },
		],
		interval = 1.0,
	},
]

var lives: int = 10
var coins: int = 100
var wave_number: int = 0
var is_wave_active: bool = false
var mobs_alive: int = 0


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


func mob_spawned() -> void:
	mobs_alive += 1


func mob_destroyed() -> void:
	mobs_alive -= 1
	if mobs_alive <= 0 and is_wave_active:
		is_wave_active = false
		wave_completed.emit()


func get_wave(index: int) -> Dictionary:
	return WAVES[index % WAVES.size()]
