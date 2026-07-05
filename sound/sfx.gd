extends Node

const SOUNDS: Dictionary = {
	"build": preload("res://sound/build.wav"),
	"tier1": preload("res://sound/tier1.wav"),
	"tier2": preload("res://sound/tier2.wav"),
	"pause": preload("res://sound/pause.wav"),
	"damage": preload("res://sound/damage.wav"),
}


func play(sound_name: String) -> void:
	var stream: AudioStream = SOUNDS.get(sound_name)
	if not stream:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.process_mode = PROCESS_MODE_ALWAYS
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
