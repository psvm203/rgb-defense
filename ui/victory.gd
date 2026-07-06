extends CanvasLayer

const WaveData = preload("res://level/wave.gd")

@onready var _main_btn: TextureButton = $CenterContainer/WinContainer/HBoxContainer/MainBtn
@onready var _next_btn: TextureButton = $CenterContainer/WinContainer/HBoxContainer/NextBtn


func _ready() -> void:
	_main_btn.pressed.connect(_on_main_pressed)
	_next_btn.pressed.connect(_on_next_pressed)

	var maxed_out := GameState.current_level >= WaveData.MAX_LEVEL
	var next_locked := not GameState.is_level_unlocked(GameState.current_level + 1)
	if maxed_out or next_locked:
		_next_btn.disabled = true
		_next_btn.modulate = Color(0.5, 0.5, 0.5)


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_next_pressed() -> void:
	get_tree().paused = false
	if GameState.current_level < WaveData.MAX_LEVEL:
		GameState.current_level += 1
		get_tree().change_scene_to_file("res://track/track.tscn")
