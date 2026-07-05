extends CanvasLayer

signal tower_selected(scene_path: String, cost: int)
signal selection_cancelled

const TOWERS: Array[Dictionary] = [
	{
		name = "Warrior",
		scene = "res://tower/red/warrior/warrior.tscn",
		icon = "res://tower/red/warrior/warrior_icon.png",
		cost = 25,
		color = Color(1.0, 0.2, 0.2),
	},
	{
		name = "Archer",
		scene = "res://tower/green/archer/archer.tscn",
		icon = "res://tower/green/archer/archer_icon.png",
		cost = 50,
		color = Color(0.2, 1.0, 0.2),
	},
	{
		name = "Mage",
		scene = "res://tower/blue/mage/mage.tscn",
		icon = "res://tower/blue/mage/mage_icon.png",
		cost = 75,
		color = Color(0.2, 0.2, 1.0),
	},
]


func _ready() -> void:
	_build_buttons()


func _build_buttons() -> void:
	var coin_tex := preload("res://game_state/coins.png")
	for tower in TOWERS:
		if GameState.current_level == 1 and tower.name != "Warrior":
			continue
		var row := HBoxContainer.new()
		row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

		var icon := TextureRect.new()
		icon.texture = load(tower.icon)
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(24, 24)
		row.add_child(icon)

		var coin := TextureRect.new()
		coin.texture = coin_tex
		coin.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		coin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		coin.custom_minimum_size = Vector2(16, 16)
		row.add_child(coin)

		var label := Label.new()
		label.text = str(tower.cost)
		row.add_child(label)

		row.gui_input.connect(_on_tower_row_input.bind(tower.scene, tower.cost))
		$Panel/VBox/TowerList.add_child(row)


func _on_tower_row_input(event: InputEvent, scene_path: String, cost: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tower_selected.emit(scene_path, cost)


func _on_cancel_pressed() -> void:
	selection_cancelled.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		_on_cancel_pressed()
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		_on_cancel_pressed()
