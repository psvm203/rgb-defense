extends CanvasLayer

@onready var _menu_panel: VBoxContainer = $MenuPanel
@onready var _level_list: VBoxContainer = $MenuPanel/LevelList
@onready var _settings_panel: VBoxContainer = $SettingsPanel
@onready var _res_option: OptionButton = $SettingsPanel/ResHBox/ResOption
@onready var _fullscreen_check: CheckButton = $SettingsPanel/FullscreenCheck
@onready var _volume_slider: HSlider = $SettingsPanel/VolumeHBox/VolumeSlider

const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(960, 540),
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
]
const CONFIG_SECTION := "display"
const CONFIG_RES_INDEX := "resolution_index"
const CONFIG_FULLSCREEN := "fullscreen"
const CONFIG_VOLUME := "volume"
const MASTER_BUS := 0
const MIN_VOLUME_DB := -40.0


func _ready() -> void:
	_load_settings()
	_apply_settings()
	_create_level_buttons()


func _create_level_buttons() -> void:
	var debug_btn := Button.new()
	debug_btn.custom_minimum_size = Vector2(200, 50)
	debug_btn.text = "Debug"
	debug_btn.pressed.connect(_on_level_pressed.bind(0))
	_level_list.add_child(debug_btn)

	for level in range(1, GameState.MAX_LEVEL + 1):
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(200, 50)
		if GameState.is_level_unlocked(level):
			btn.text = "Level %d" % level
			btn.pressed.connect(_on_level_pressed.bind(level))
		else:
			btn.text = "Level %d - Locked" % level
			btn.disabled = true
		_level_list.add_child(btn)


func _on_level_pressed(level: int) -> void:
	GameState.current_level = level
	get_tree().change_scene_to_file("res://track/track.tscn")


func _on_settings_pressed() -> void:
	_menu_panel.visible = false
	_settings_panel.visible = true


func _on_back_pressed() -> void:
	_settings_panel.visible = false
	_menu_panel.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resolution_changed(_index: int) -> void:
	_save_settings()
	_apply_settings()


func _on_fullscreen_toggled(_on: bool) -> void:
	_save_settings()
	_apply_settings()


func _on_volume_changed(_value: float) -> void:
	_apply_volume()
	_save_settings()


func _apply_settings() -> void:
	var index := _res_option.selected
	var size := RESOLUTIONS[index]
	if _fullscreen_check.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(size)
	_apply_volume()


func _apply_volume() -> void:
	var db := lerpf(MIN_VOLUME_DB, 0.0, _volume_slider.value / 100.0)
	AudioServer.set_bus_volume_db(MASTER_BUS, db)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value(CONFIG_SECTION, CONFIG_RES_INDEX, _res_option.selected)
	config.set_value(CONFIG_SECTION, CONFIG_FULLSCREEN, _fullscreen_check.button_pressed)
	config.set_value(CONFIG_SECTION, CONFIG_VOLUME, _volume_slider.value)
	config.save("user://settings.cfg")


func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return
	_res_option.selected = config.get_value(CONFIG_SECTION, CONFIG_RES_INDEX, 0)
	_fullscreen_check.button_pressed = config.get_value(CONFIG_SECTION, CONFIG_FULLSCREEN, false)
	_volume_slider.value = config.get_value(CONFIG_SECTION, CONFIG_VOLUME, 100.0)
