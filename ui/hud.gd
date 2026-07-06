extends CanvasLayer

const WaveData = preload("res://level/wave.gd")

const MAX_GROUPS := 3

@onready var _lives_label: Label = $TopPanel/VBox/Lives/LivesLabel
@onready var _coins_label: Label = $TopPanel/VBox/Coins/CoinsLabel
@onready var _wave_label: Label = $TopPanel/VBox/WaveLabel
@onready var _wave_mobs: VBoxContainer = $WavePanel/VBox/WaveMobs
@onready var _start_wave_btn: Button = $WavePanel/VBox/StartWaveBtn
@onready var _pause_overlay: ColorRect = $PauseOverlay
@onready var _pause_menu: VBoxContainer = $PauseOverlay/PauseMenuPanel
@onready var _tutorial_label: Label = $TutorialPanel/TutorialLabel
@onready var _tutorial_panel: PanelContainer = $TutorialPanel

var _track: Node2D
var _tower_info_label: Label
var _tower_info_panel: PanelContainer
var _settings_scene: Control

var _group_rows: Array = []
var _tutorial_step: int = -1

const TUTORIAL_MESSAGES: Dictionary = {
	1: [
		"타워를 설치해보세요!\n오른쪽 패널에서 Warrior를 선택하거나 R키를 누르세요.",
		"하단의 Start Wave 버튼 또는 스페이스바를 눌러\n웨이브를 시작하세요!",
		"적이 경로 끝에 도달하면 생명을 잃습니다. 빠르게 처치하세요!",
	],
	2: [
		"같은 색의 적에게는 3배의 피해를 줍니다!",
		"설치한 타워는 클릭 메뉴에서 90% 가격으로 판매가 가능합니다.",
	],
	3: [
		"타워를 클릭하면 전직시킬 수 있습니다.",
		"전직한 타워는 더 강력한 공격력과 특수 능력을 가집니다.\n3가지 전직 중 하나를 선택하세요!",
		"전직 타워도 한번 더 전직시킬 수 있습니다!",
	],
	4: [
		"이제부터 복합 색 몹이 등장합니다!\n예: 보라 = 빨강 + 파랑",
		"빨강 타워만 배치한다면 파란 체력을 빠르게 깎을 수 없습니다.",
		"빨강 타워와 파란 타워를 모두 배치하여 처치하세요!",
	],
}


func _ready() -> void:
	_track = get_parent()
	_start_wave_btn.pressed.connect(_on_start_wave_pressed)
	_apply_button_style(_start_wave_btn)

	$PauseOverlay/PauseSettingsPanel.hide()

	_settings_scene = preload("res://ui/settings.tscn").instantiate()
	_settings_scene.back.connect(_on_settings_back)
	_settings_scene.hide()
	$PauseOverlay.add_child(_settings_scene)

	var dialog_style := StyleBoxFlat.new()
	dialog_style.bg_color = Color(0.1, 0.1, 0.15, 0.85)
	dialog_style.border_width_left = 2
	dialog_style.border_width_right = 2
	dialog_style.border_width_top = 2
	dialog_style.border_width_bottom = 2
	dialog_style.border_color = Color(0.5, 0.5, 0.6, 0.8)
	dialog_style.corner_radius_top_left = 12
	dialog_style.corner_radius_top_right = 12
	dialog_style.corner_radius_bottom_left = 12
	dialog_style.corner_radius_bottom_right = 12
	dialog_style.content_margin_left = 20.0
	dialog_style.content_margin_right = 20.0
	dialog_style.content_margin_top = 16.0
	dialog_style.content_margin_bottom = 16.0
	_tutorial_panel.add_theme_stylebox_override("panel", dialog_style)
	_tutorial_label.add_theme_color_override("font_color", Color.WHITE)
	_tutorial_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_tutorial_label.add_theme_constant_override("outline_size", 4)
	_tutorial_panel.offset_bottom = 180.0
	var tutorial_messages: Array = TUTORIAL_MESSAGES.get(GameState.current_level, [])
	if not tutorial_messages.is_empty():
		_tutorial_step = 0
		_tutorial_label.text = tutorial_messages[0]
	else:
		_tutorial_panel.hide()
	for i in range(MAX_GROUPS):
		var row := HBoxContainer.new()
		var icon := TextureRect.new()
		icon.texture = preload("res://mob/slime_icon.png")
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(36, 36)
		var label := Label.new()
		label.add_theme_color_override(&"font_color", Color.BLACK)
		row.add_child(icon)
		row.add_child(label)
		_wave_mobs.add_child(row)
		_group_rows.append({ row = row, icon = icon, label = label })

	_tower_info_panel = PanelContainer.new()
	_tower_info_panel.offset_left = 300
	_tower_info_panel.offset_right = -300
	_tower_info_panel.offset_top = -80
	_tower_info_panel.offset_bottom = -20
	_tower_info_panel.anchor_left = 0.5
	_tower_info_panel.anchor_right = 0.5
	_tower_info_panel.anchor_bottom = 1.0
	var info_style := StyleBoxFlat.new()
	info_style.bg_color = Color(0.1, 0.1, 0.15, 0.85)
	info_style.border_width_left = 2
	info_style.border_width_right = 2
	info_style.border_width_top = 2
	info_style.border_width_bottom = 2
	info_style.border_color = Color(0.5, 0.5, 0.6, 0.8)
	info_style.corner_radius_top_left = 8
	info_style.corner_radius_top_right = 8
	info_style.corner_radius_bottom_left = 8
	info_style.corner_radius_bottom_right = 8
	info_style.content_margin_left = 16
	info_style.content_margin_right = 16
	info_style.content_margin_top = 8
	info_style.content_margin_bottom = 8
	_tower_info_panel.add_theme_stylebox_override(&"panel", info_style)

	_tower_info_label = Label.new()
	_tower_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_tower_info_label.add_theme_color_override(&"font_color", Color.WHITE)
	_tower_info_panel.add_child(_tower_info_label)
	_tower_info_panel.hide()
	add_child(_tower_info_panel)


func _process(_delta: float) -> void:
	var max_lives := WaveData.get_starting_lives(GameState.current_level)
	_lives_label.text = "%d/%d" % [GameState.lives, max_lives]
	_coins_label.text = str(GameState.coins)
	var total_waves := WaveData.get_waves(GameState.current_level).size()
	_wave_label.text = "Wave %d/%d" % [_track.wave_number, total_waves]
	_start_wave_btn.disabled = _track.is_wave_active

	var wave: Dictionary = WaveData.get_wave(GameState.current_level, _track.wave_number)
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
		if _track.is_suppressing_pause():
			return
		if get_tree().paused:
			if _settings_scene.visible:
				_on_settings_back()
			else:
				_resume()
		else:
			_pause()

	_update_tutorial()


func _rgb_color(max_rgb: Vector3) -> Color:
	return Color(
		1.0 if max_rgb.x > 0.0 else 0.0,
		1.0 if max_rgb.y > 0.0 else 0.0,
		1.0 if max_rgb.z > 0.0 else 0.0,
	)


func _on_start_wave_pressed() -> void:
	_track.start_wave_pressed.emit()


func _apply_button_style(btn: Button) -> void:
	var normal_style := StyleBoxTexture.new()
	normal_style.texture = preload("res://ui/button.png")
	btn.add_theme_stylebox_override(&"normal", normal_style)

	var pressed_style := StyleBoxTexture.new()
	pressed_style.texture = preload("res://ui/button_pressed.png")
	btn.add_theme_stylebox_override(&"pressed", pressed_style)


func _pause() -> void:
	get_tree().paused = true
	SfxPlayer.play("pause")
	_pause_overlay.visible = true
	_pause_menu.visible = true
	_settings_scene.hide()


func _resume() -> void:
	get_tree().paused = false
	_pause_overlay.visible = false
	_pause_menu.visible = true
	_settings_scene.hide()


func _on_resume_pressed() -> void:
	_resume()


func _on_pause_settings_pressed() -> void:
	_pause_menu.visible = false
	_settings_scene.show()


func _on_settings_back() -> void:
	_settings_scene.hide()
	_pause_menu.visible = true


func _on_main_menu_pressed() -> void:
	_resume()
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _update_tutorial() -> void:
	var tutorial_messages: Array = TUTORIAL_MESSAGES.get(GameState.current_level, [])
	if tutorial_messages.is_empty():
		return
	match _tutorial_step:
		0:
			if not get_tree().get_nodes_in_group("towers").is_empty():
				_advance_tutorial()
		1:
			if _track.is_wave_active:
				_advance_tutorial()
		2:
			if _track.wave_number > 0 and not _track.is_wave_active:
				_advance_tutorial()


func _advance_tutorial() -> void:
	var tutorial_messages: Array = TUTORIAL_MESSAGES.get(GameState.current_level, [])
	_tutorial_step += 1
	if _tutorial_step >= tutorial_messages.size():
		_tutorial_panel.hide()
	else:
		_tutorial_label.text = tutorial_messages[_tutorial_step]


func show_tower_info(damage: float, attack_range: float) -> void:
	_tower_info_label.text = "Damage: %.1f  |  Range: %.0f" % [damage, attack_range]
	_tower_info_panel.show()


func hide_tower_info() -> void:
	_tower_info_panel.hide()
