extends CanvasLayer

@onready var _menu_panel: VBoxContainer = $MenuPanel
@onready var _settings_panel: VBoxContainer = $SettingsPanel
@onready var _res_option: OptionButton = $SettingsPanel/ResHBox/ResOption
@onready var _fullscreen_check: CheckButton = $SettingsPanel/FullscreenCheck
@onready var _volume_slider: HSlider = $SettingsPanel/VolumeHBox/VolumeSlider
@onready var _stage_label: Label = $MenuPanel/StageHBox/StageLabel
@onready var _prev_btn: TextureButton = $MenuPanel/StageHBox/PrevWrapper/PrevBtn
@onready var _next_btn: TextureButton = $MenuPanel/StageHBox/NextWrapper/NextBtn
@onready var _start_btn: TextureButton = $MenuPanel/StartWrapper/StartBtn
@onready var _start_label: Label = $MenuPanel/StartWrapper/StartBtn/Label

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

var _selected_level: int = 1


func _ready() -> void:
	_load_settings()
	_apply_settings()
	_update_stage_display()


func _update_stage_display() -> void:
	var level_names := _get_level_names()
	_stage_label.text = level_names[_selected_level]
	_prev_btn.disabled = _selected_level <= 0
	_next_btn.disabled = _selected_level >= GameState.MAX_LEVEL
	_start_btn.disabled = not _is_level_available(_selected_level)
	_start_label.text = "Start"


func _get_level_names() -> Array:
	return ["Debug Stage", "Level 1", "Level 2", "Level 3", "Level 4"]


func _is_level_available(level: int) -> bool:
	return level == 0 or GameState.is_level_unlocked(level)


func _on_prev_stage() -> void:
	if _selected_level > 0:
		_selected_level -= 1
		_update_stage_display()


func _on_next_stage() -> void:
	if _selected_level < GameState.MAX_LEVEL:
		_selected_level += 1
		_update_stage_display()


func _on_start_pressed() -> void:
	GameState.current_level = _selected_level
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
