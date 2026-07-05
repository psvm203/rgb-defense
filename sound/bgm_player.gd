extends Node

func _ready() -> void:
	var player := AudioStreamPlayer.new()
	player.stream = preload("res://sound/bgm.wav")
	player.finished.connect(player.play)
	add_child(player)
	player.play()
