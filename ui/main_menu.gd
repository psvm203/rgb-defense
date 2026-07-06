extends CanvasLayer

const WaveData = preload("res://level/wave.gd")

@onready var _menu_panel: VBoxContainer = $MenuPanel
@onready var _stage_label: Label = $MenuPanel/StageHBox/StageLabel
@onready var _prev_btn: TextureButton = $MenuPanel/StageHBox/PrevWrapper/PrevBtn
@onready var _next_btn: TextureButton = $MenuPanel/StageHBox/NextWrapper/NextBtn
@onready var _start_btn: TextureButton = $MenuPanel/StartWrapper/StartBtn
@onready var _start_label: Label = $MenuPanel/StartWrapper/StartBtn/Label

var _selected_level: int = 1
var _settings_scene: Control
var _tower_anims: Array[Dictionary] = []
var _tower_anim_time: float = 0.0
const TOWER_ANIM_SPEED := 5.0


func _ready() -> void:
	$SettingsPanel.hide()
	_settings_scene = preload("res://ui/settings.tscn").instantiate()
	_settings_scene.back.connect(_on_settings_back)
	_settings_scene.hide()
	add_child(_settings_scene)
	_update_stage_display()
	_animate_towers()


func _process(delta: float) -> void:
	_tower_anim_time += delta
	var frame_index: int = int(_tower_anim_time * TOWER_ANIM_SPEED)
	for anim in _tower_anims:
		var fc: int = anim.frame_count
		var fs: int = anim.frame_size
		var current_frame: int = frame_index % fc
		var atlas_tex: AtlasTexture = anim.tex_rect.texture
		atlas_tex.region = Rect2(
			current_frame * fs,
			0,
			fs,
			fs,
		)


func _animate_towers() -> void:
	var tower_row := $TowerRow
	for child in tower_row.get_children():
		if not child is TextureRect:
			continue
		var tex_rect: TextureRect = child
		var atlas_tex: AtlasTexture = tex_rect.texture
		if atlas_tex == null:
			continue
		var atlas: Texture2D = atlas_tex.atlas
		if atlas == null:
			continue
		var frame_size := int(atlas.get_height())
		if int(atlas.get_width()) % frame_size != 0:
			continue
		var frame_count := int(float(atlas.get_width()) / frame_size)
		if frame_count <= 1:
			continue
		_tower_anims.append(
			{
				tex_rect = tex_rect,
				atlas = atlas,
				frame_count = frame_count,
				frame_size = frame_size,
			},
		)


func _update_stage_display() -> void:
	var level_names := _get_level_names()
	_stage_label.text = level_names[_selected_level]
	_prev_btn.disabled = _selected_level <= 0
	_next_btn.disabled = _selected_level >= WaveData.MAX_LEVEL
	_start_btn.disabled = not _is_level_available(_selected_level)
	_start_label.text = "Start"


func _get_level_names() -> Array:
	return [
		"Debug Stage",
		"Level 1",
		"Level 2",
		"Level 3",
		"Level 4",
		"Level 5",
		"Level 6",
		"Level 7",
		"Level 8",
		"Level 9",
		"Level 10",
	]


func _is_level_available(level: int) -> bool:
	return level == 0 or GameState.is_level_unlocked(level)


func _on_prev_stage() -> void:
	if _selected_level > 0:
		_selected_level -= 1
		_update_stage_display()


func _on_next_stage() -> void:
	if _selected_level < WaveData.MAX_LEVEL:
		_selected_level += 1
		_update_stage_display()


func _on_start_pressed() -> void:
	GameState.current_level = _selected_level
	get_tree().change_scene_to_file("res://track/track.tscn")


func _on_settings_pressed() -> void:
	_menu_panel.visible = false
	_settings_scene.show()


func _on_settings_back() -> void:
	_settings_scene.hide()
	_menu_panel.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
