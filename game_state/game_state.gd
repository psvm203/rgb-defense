extends Node

signal wave_completed

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
