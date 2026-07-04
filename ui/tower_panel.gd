extends CanvasLayer

signal tower_selected(scene_path: String, cost: int)
signal selection_cancelled

const TOWERS: Array[Dictionary] = [
	{
		name = "Warrior",
		scene = "res://tower/warrior/warrior.tscn",
		cost = 25,
		color = Color(1.0, 0.2, 0.2),
	},
	{
		name = "Archer",
		scene = "res://tower/archer/archer.tscn",
		cost = 50,
		color = Color(0.2, 1.0, 0.2),
	},
	{
		name = "Mage",
		scene = "res://tower/mage/mage.tscn",
		cost = 75,
		color = Color(0.2, 0.2, 1.0),
	},
]

var _buttons: Array[Button] = []


func _ready() -> void:
	_build_buttons()


func _build_buttons() -> void:
	for tower in TOWERS:
		var btn := Button.new()
		btn.text = "%s - %d" % [tower.name, tower.cost]
		btn.pressed.connect(_on_tower_button_pressed.bind(tower.scene, tower.cost))
		$Panel/VBox/TowerList.add_child(btn)
		_buttons.append(btn)


func _on_tower_button_pressed(scene_path: String, cost: int) -> void:
	tower_selected.emit(scene_path, cost)


func _on_cancel_pressed() -> void:
	selection_cancelled.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		_on_cancel_pressed()
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		_on_cancel_pressed()
