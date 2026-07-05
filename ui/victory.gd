extends CanvasLayer

@onready var _main_btn: TextureButton = $CenterContainer/WinContainer/HBoxContainer/MainBtn
@onready var _next_btn: TextureButton = $CenterContainer/WinContainer/HBoxContainer/NextBtn


func _ready() -> void:
	_main_btn.pressed.connect(_on_main_pressed)
	_next_btn.pressed.connect(_on_next_pressed)

	if GameState.current_level >= GameState.MAX_LEVEL:
		_next_btn.disabled = true
		_next_btn.modulate = Color(0.5, 0.5, 0.5)


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_next_pressed() -> void:
	get_tree().paused = false
	if GameState.current_level < GameState.MAX_LEVEL:
		GameState.current_level += 1
		get_tree().change_scene_to_file("res://track/track.tscn")
