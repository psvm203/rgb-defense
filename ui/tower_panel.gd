extends CanvasLayer

signal tower_selected(scene_path: String, cost: int)
signal selection_cancelled

const TOWERS: Array[Dictionary] = [
	{
		name = "Warrior",
		scene = "res://tower/red/warrior/warrior.tscn",
		icon = "res://tower/red/warrior/warrior_icon.png",
		cost = 25,
		color = Color(0.9, 0.2, 0.2),
		shortcut = "R",
	},
	{
		name = "Archer",
		scene = "res://tower/green/archer/archer.tscn",
		icon = "res://tower/green/archer/archer_icon.png",
		cost = 50,
		color = Color(0.2, 0.9, 0.2),
		shortcut = "G",
	},
	{
		name = "Mage",
		scene = "res://tower/blue/mage/mage.tscn",
		icon = "res://tower/blue/mage/mage_icon.png",
		cost = 75,
		color = Color(0.3, 0.4, 1.0),
		shortcut = "B",
	},
]


func _ready() -> void:
	_build_panels()


func _build_panels() -> void:
	var coin_tex := preload("res://game_state/coins.png")
	for tower in TOWERS:
		if GameState.current_level == 1 and tower.name != "Warrior":
			continue

		var card := PanelContainer.new()
		card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		card.add_theme_stylebox_override(&"panel", _make_card_stylebox())

		var content := VBoxContainer.new()
		content.add_theme_constant_override(&"separation", 4)

		var icon_box := Control.new()
		icon_box.custom_minimum_size = Vector2(96, 96)

		var icon := TextureRect.new()
		icon.texture = load(tower.icon)
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.anchor_right = 1.0
		icon.anchor_bottom = 1.0
		icon_box.add_child(icon)

		var shortcut_label := Label.new()
		shortcut_label.text = "[%s]" % tower.shortcut
		shortcut_label.add_theme_color_override(&"font_color", tower.color)
		shortcut_label.add_theme_font_size_override(&"font_size", 16)
		shortcut_label.offset_left = 4
		shortcut_label.offset_top = 2
		icon_box.add_child(shortcut_label)

		content.add_child(icon_box)

		var name_label := Label.new()
		name_label.text = tower.name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		content.add_child(name_label)

		var price_row := HBoxContainer.new()
		price_row.alignment = BoxContainer.ALIGNMENT_CENTER
		price_row.add_theme_constant_override(&"separation", 4)

		var coin := TextureRect.new()
		coin.texture = coin_tex
		coin.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		coin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		coin.custom_minimum_size = Vector2(16, 16)
		price_row.add_child(coin)

		var price_label := Label.new()
		price_label.text = str(tower.cost)
		price_row.add_child(price_label)

		content.add_child(price_row)
		card.add_child(content)

		card.gui_input.connect(_on_tower_card_input.bind(tower.scene, tower.cost))
		$Panel/VBox/TowerList.add_child(card)


func _make_card_stylebox() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.1, 0.1, 0.1, 0.7)
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.border_width_top = 2
	sb.border_width_bottom = 2
	sb.border_color = Color(0.3, 0.3, 0.3, 0.8)
	sb.corner_radius_top_left = 8
	sb.corner_radius_top_right = 8
	sb.corner_radius_bottom_left = 8
	sb.corner_radius_bottom_right = 8
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	return sb


func _on_tower_card_input(event: InputEvent, scene_path: String, cost: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tower_selected.emit(scene_path, cost)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		selection_cancelled.emit()
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		selection_cancelled.emit()
