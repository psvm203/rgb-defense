extends Node

func _ready() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, "Music")
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, "SFX")

	var player := AudioStreamPlayer.new()
	player.stream = preload("res://sound/bgm.wav")
	player.bus = "Music"
	player.finished.connect(player.play)
	add_child(player)
	player.play()
