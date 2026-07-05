extends Node

const SOUNDS: Dictionary = {
	"build": preload("res://sound/build.wav"),
	"tier1": preload("res://sound/tier1.wav"),
	"tier2": preload("res://sound/tier2.wav"),
	"pause": preload("res://sound/pause.wav"),
	"damage": preload("res://sound/damage.wav"),
	"sword": preload("res://sound/sword.wav"),
	"sword_aura": preload("res://sound/sword_aura.wav"),
	"brawler_punch": preload("res://sound/brawler_punch.wav"),
	"brawler_knockback": preload("res://sound/brawler_knockback.wav"),
	"magic": preload("res://sound/magic.wav"),
	"thunder": preload("res://sound/thunder.wav"),
	"summon": preload("res://sound/summon.wav"),
}


func play(sound_name: String) -> void:
	var stream: AudioStream = SOUNDS.get(sound_name)
	if not stream:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "SFX"
	player.process_mode = PROCESS_MODE_ALWAYS
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
