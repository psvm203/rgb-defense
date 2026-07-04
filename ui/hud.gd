extends CanvasLayer

const MAX_GROUPS := 3

@onready var _lives_label: Label = $TopPanel/VBox/Lives/LivesLabel
@onready var _coins_label: Label = $TopPanel/VBox/Coins/CoinsLabel
@onready var _wave_label: Label = $TopPanel/VBox/WaveLabel
@onready var _wave_mobs: VBoxContainer = $WavePanel/VBox/WaveMobs
@onready var _start_wave_btn: Button = $WavePanel/VBox/StartWaveBtn

var _group_rows: Array = []


func _ready() -> void:
	_start_wave_btn.pressed.connect(_on_start_wave_pressed)
	for i in range(MAX_GROUPS):
		var row := HBoxContainer.new()
		var icon := TextureRect.new()
		icon.texture = preload("res://mob/slime_idle.png")
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(24, 24)
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


func _rgb_color(max_rgb: Vector3) -> Color:
	return Color(
		1.0 if max_rgb.x > 0.0 else 0.0,
		1.0 if max_rgb.y > 0.0 else 0.0,
		1.0 if max_rgb.z > 0.0 else 0.0,
	)


func _on_start_wave_pressed() -> void:
	GameState.start_wave_pressed.emit()
