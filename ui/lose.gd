extends CanvasLayer

@onready var _main_btn: TextureButton = $CenterContainer/LoseContainer/HBoxContainer/MainBtn
@onready var _retry_btn: TextureButton = $CenterContainer/LoseContainer/HBoxContainer/RetryBtn


func _ready() -> void:
	_main_btn.pressed.connect(_on_main_pressed)
	_retry_btn.pressed.connect(_on_retry_pressed)


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://track/track.tscn")
