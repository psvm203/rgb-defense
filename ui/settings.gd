extends Control

signal back

@onready var _res_option: OptionButton = $Panel/VBox/ResHBox/ResOption
@onready var _fullscreen_check: CheckButton = $Panel/VBox/FullscreenCheck
@onready var _bgm_slider: HSlider = $Panel/VBox/BgmHBox/BgmSlider
@onready var _sfx_slider: HSlider = $Panel/VBox/SfxHBox/SfxSlider
@onready var _back_btn: Button = $Panel/VBox/BackBtn

const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(960, 540),
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
]
const CONFIG_SECTION := "display"
const CONFIG_RES_INDEX := "resolution_index"
const CONFIG_FULLSCREEN := "fullscreen"
const CONFIG_BGM_VOLUME := "bgm_volume"
const CONFIG_SFX_VOLUME := "sfx_volume"
const CONFIG_OLD_VOLUME := "volume"
const MIN_VOLUME_DB := -40.0


func _ready() -> void:
	for res in RESOLUTIONS:
		_res_option.add_item("%dx%d" % [res.x, res.y])
	_res_option.item_selected.connect(_on_resolution_changed)
	_fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	_bgm_slider.value_changed.connect(_on_bgm_volume_changed)
	_sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	_back_btn.pressed.connect(_on_back_pressed)

	_load_settings()
	_apply_settings()


func _on_back_pressed() -> void:
	back.emit()


func _on_resolution_changed(_index: int) -> void:
	_save_settings()
	_apply_settings()


func _on_fullscreen_toggled(_on: bool) -> void:
	_save_settings()
	_apply_settings()


func _on_bgm_volume_changed(_value: float) -> void:
	_apply_volume()
	_save_settings()


func _on_sfx_volume_changed(_value: float) -> void:
	_apply_volume()
	_save_settings()


func _apply_settings() -> void:
	var index := _res_option.selected
	var res := RESOLUTIONS[index]
	if _fullscreen_check.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(res)
	_apply_volume()


func _apply_volume() -> void:
	var bgm_db := lerpf(MIN_VOLUME_DB, 0.0, _bgm_slider.value / 100.0)
	var bgm_idx := AudioServer.get_bus_index("Music")
	if bgm_idx != -1:
		AudioServer.set_bus_volume_db(bgm_idx, bgm_db)
	var sfx_db := lerpf(MIN_VOLUME_DB, 0.0, _sfx_slider.value / 100.0)
	var sfx_idx := AudioServer.get_bus_index("SFX")
	if sfx_idx != -1:
		AudioServer.set_bus_volume_db(sfx_idx, sfx_db)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value(CONFIG_SECTION, CONFIG_RES_INDEX, _res_option.selected)
	config.set_value(CONFIG_SECTION, CONFIG_FULLSCREEN, _fullscreen_check.button_pressed)
	config.set_value(CONFIG_SECTION, CONFIG_BGM_VOLUME, _bgm_slider.value)
	config.set_value(CONFIG_SECTION, CONFIG_SFX_VOLUME, _sfx_slider.value)
	config.save("user://settings.cfg")


func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return
	_res_option.selected = config.get_value(CONFIG_SECTION, CONFIG_RES_INDEX, 0)
	_fullscreen_check.button_pressed = config.get_value(CONFIG_SECTION, CONFIG_FULLSCREEN, false)
	_bgm_slider.value = config.get_value(
		CONFIG_SECTION,
		CONFIG_BGM_VOLUME,
		config.get_value(CONFIG_SECTION, CONFIG_OLD_VOLUME, 100.0),
	)
	_sfx_slider.value = config.get_value(CONFIG_SECTION, CONFIG_SFX_VOLUME, 100.0)
