extends CanvasLayer

const MAX_GROUPS := 3

@onready var _lives_label: Label = $TopPanel/VBox/Lives/LivesLabel
@onready var _coins_label: Label = $TopPanel/VBox/Coins/CoinsLabel
@onready var _wave_label: Label = $TopPanel/VBox/WaveLabel
@onready var _wave_mobs: VBoxContainer = $WavePanel/VBox/WaveMobs
@onready var _start_wave_btn: Button = $WavePanel/VBox/StartWaveBtn
@onready var _pause_overlay: ColorRect = $PauseOverlay
@onready var _pause_menu: VBoxContainer = $PauseOverlay/PauseMenuPanel
@onready var _pause_settings: VBoxContainer = $PauseOverlay/PauseSettingsPanel
@onready var _res_option: OptionButton = $PauseOverlay/PauseSettingsPanel/ResHBox/ResOption
@onready var _fullscreen_check: CheckButton = $PauseOverlay/PauseSettingsPanel/FullscreenCheck
@onready var _volume_slider: HSlider = $PauseOverlay/PauseSettingsPanel/VolumeHBox/VolumeSlider

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

var _group_rows: Array = []


func _ready() -> void:
	_start_wave_btn.pressed.connect(_on_start_wave_pressed)
	_load_settings()
	_apply_settings()
	for i in range(MAX_GROUPS):
		var row := HBoxContainer.new()
		var icon := TextureRect.new()
		icon.texture = preload("res://mob/slime_icon.png")
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(36, 36)
		var label := Label.new()
		row.add_child(icon)
		row.add_child(label)
		_wave_mobs.add_child(row)
		_group_rows.append({ row = row, icon = icon, label = label })


func _process(_delta: float) -> void:
	_lives_label.text = str(GameState.lives)
	_coins_label.text = str(GameState.coins)
	_wave_label.text = "Wave " + str(GameState.wave_number)
	_start_wave_btn.disabled = GameState.is_wave_active

	var wave: Dictionary = GameState.get_wave(GameState.wave_number)
	var groups: Array = wave.groups
	for i in range(MAX_GROUPS):
		var row_data: Dictionary = _group_rows[i]
		if i < groups.size():
			var group: Dictionary = groups[i]
			row_data.row.visible = true
			row_data.icon.modulate = _rgb_color(group.max_rgb)
			row_data.label.text = "x%d" % group.count
		else:
			row_data.row.visible = false

	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			if _pause_settings.visible:
				_on_pause_settings_back_pressed()
			else:
				_resume()
		else:
			_pause()


func _rgb_color(max_rgb: Vector3) -> Color:
	return Color(
		1.0 if max_rgb.x > 0.0 else 0.0,
		1.0 if max_rgb.y > 0.0 else 0.0,
		1.0 if max_rgb.z > 0.0 else 0.0,
	)


func _on_start_wave_pressed() -> void:
	GameState.start_wave_pressed.emit()


func _pause() -> void:
	get_tree().paused = true
	_pause_overlay.visible = true
	_pause_menu.visible = true
	_pause_settings.visible = false


func _resume() -> void:
	get_tree().paused = false
	_pause_overlay.visible = false
	_pause_menu.visible = true
	_pause_settings.visible = false


func _on_resume_pressed() -> void:
	_resume()


func _on_pause_settings_pressed() -> void:
	_pause_menu.visible = false
	_pause_settings.visible = true


func _on_pause_settings_back_pressed() -> void:
	_pause_settings.visible = false
	_pause_menu.visible = true


func _on_main_menu_pressed() -> void:
	_resume()
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_pause_resolution_changed(_index: int) -> void:
	_save_settings()
	_apply_settings()


func _on_pause_fullscreen_toggled(_on: bool) -> void:
	_save_settings()
	_apply_settings()


func _on_pause_volume_changed(_value: float) -> void:
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
