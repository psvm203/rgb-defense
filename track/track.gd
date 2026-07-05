extends Node2D

const GRID_UNIT: int = 64
const MAP_SIZE := Vector2i(15, 9)
const HALF_GRID := Vector2(GRID_UNIT / 2.0, GRID_UNIT / 2.0)

const TRACK_GRID: Array[Vector2i] = [
	Vector2i(0, 4),
	Vector2i(4, 4),
	Vector2i(4, 2),
	Vector2i(8, 2),
	Vector2i(8, 4),
	Vector2i(6, 4),
	Vector2i(6, 6),
	Vector2i(10, 6),
	Vector2i(10, 2),
	Vector2i(12, 2),
	Vector2i(12, 8),
]

var _spawn_queue: Array[Vector3] = []
var _spawn_timer: Timer
var _mob_scene: PackedScene
var _selected_tower_scene: PackedScene
var _selected_tower_cost: int
var _preview: Node2D
var _occupied_cells: Array[Vector2i] = []
var _tower_menu: Control
var _upgrade_btns: Array[Button] = []
var _sell_btn: Button
var _selected_tower: Node2D

const UPGRADES: Dictionary = {
	"res://tower/red/warrior/warrior.tscn": [
		{
			name = "Sword Saint",
			scene = "res://tower/red/sword_saint/sword_saint.tscn",
			cost = 50,
		},
		{
			name = "Barbarian",
			scene = "res://tower/red/barbarian/barbarian.tscn",
			cost = 50,
		},
		{
			name = "Brawler",
			scene = "res://tower/red/brawler/brawler.tscn",
			cost = 50,
		},
	],
	"res://tower/red/sword_saint/sword_saint.tscn": [
		{
			name = "Sword Sovereign",
			scene = "res://tower/red/sword_sovereign/sword_sovereign.tscn",
			cost = 100,
		},
	],
	"res://tower/red/barbarian/barbarian.tscn": [
		{
			name = "Berserker",
			scene = "res://tower/red/berserker/berserker.tscn",
			cost = 100,
		},
	],
	"res://tower/red/brawler/brawler.tscn": [
		{
			name = "Battle God",
			scene = "res://tower/red/battle_god/battle_god.tscn",
			cost = 100,
		},
	],
	"res://tower/green/archer/archer.tscn": [
		{
			name = "Sniper",
			scene = "res://tower/green/sniper/sniper.tscn",
			cost = 50,
		},
		{
			name = "Hunter",
			scene = "res://tower/green/hunter/hunter.tscn",
			cost = 50,
		},
		{
			name = "Viper",
			scene = "res://tower/green/viper/viper.tscn",
			cost = 50,
		},
	],
	"res://tower/green/sniper/sniper.tscn": [
		{
			name = "Deadeye",
			scene = "res://tower/green/deadeye/deadeye.tscn",
			cost = 100,
		},
	],
	"res://tower/green/hunter/hunter.tscn": [
		{
			name = "Tempest",
			scene = "res://tower/green/tempest/tempest.tscn",
			cost = 100,
		},
	],
	"res://tower/green/viper/viper.tscn": [
		{
			name = "Basilisk",
			scene = "res://tower/green/basilisk/basilisk.tscn",
			cost = 100,
		},
	],
	"res://tower/blue/mage/mage.tscn": [
		{
			name = "Electromancer",
			scene = "res://tower/blue/electromancer/electromancer.tscn",
			cost = 50,
		},
		{
			name = "Necromancer",
			scene = "res://tower/blue/necromancer/necromancer.tscn",
			cost = 50,
		},
		{
			name = "Cryomancer",
			scene = "res://tower/blue/cryomancer/cryomancer.tscn",
			cost = 50,
		},
	],
	"res://tower/blue/electromancer/electromancer.tscn": [
		{
			name = "Thunderbolt",
			scene = "res://tower/blue/thunderbolt/thunderbolt.tscn",
			cost = 100,
		},
	],
	"res://tower/blue/necromancer/necromancer.tscn": [
		{
			name = "Death Lord",
			scene = "res://tower/blue/death_lord/death_lord.tscn",
			cost = 100,
		},
	],
	"res://tower/blue/cryomancer/cryomancer.tscn": [
		{
			name = "Absolute Zero",
			scene = "res://tower/blue/absolute_zero/absolute_zero.tscn",
			cost = 100,
		},
	],
}


func _ready() -> void:
	if GameState.current_level == 0:
		GameState.lives = 10000
		GameState.coins = 10000
	RenderingServer.set_default_clear_color(Color(0.894118, 0.815686, 0.670588))
	_setup_tilemap()
	_setup_path()
	_mob_scene = preload("res://mob/mob.tscn")
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(_spawn_timer)

	var hud_scene := preload("res://ui/hud.tscn")
	add_child(hud_scene.instantiate())

	var panel_scene := preload("res://ui/tower_panel.tscn")
	var panel := panel_scene.instantiate()
	panel.tower_selected.connect(_on_tower_selected)
	panel.selection_cancelled.connect(_on_selection_cancelled)
	add_child(panel)

	GameState.mob_killed.connect(_check_wave_completion)
	GameState.start_wave_pressed.connect(start_wave)
	GameState.level_completed.connect(_on_level_completed)
	GameState.game_over.connect(_on_game_over)
	_create_tower_menu()


func _process(_delta: float) -> void:
	if not _preview:
		return
	var grid_pos := _mouse_to_grid()
	if _is_grid_valid(grid_pos):
		_preview.position = Vector2(grid_pos) * GRID_UNIT + HALF_GRID
		_preview.visible = true
	else:
		_preview.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not (
			event is InputEventMouseButton
			and event.pressed
			and event.button_index == MOUSE_BUTTON_LEFT
	):
		return
	if _preview:
		_try_place_tower()
	else:
		_try_select_tower()


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed):
		return
	match event.keycode:
		KEY_R:
			_on_tower_selected("res://tower/red/warrior/warrior.tscn", 25)
		KEY_G:
			if GameState.current_level != 1:
				_on_tower_selected("res://tower/green/archer/archer.tscn", 50)
		KEY_B:
			if GameState.current_level != 1:
				_on_tower_selected("res://tower/blue/mage/mage.tscn", 75)
		KEY_SPACE:
			if not GameState.is_wave_active:
				GameState.start_wave_pressed.emit()


func _mouse_to_grid() -> Vector2i:
	var world_pos := get_global_mouse_position()
	return Vector2i(
		floori(world_pos.x / GRID_UNIT),
		floori(world_pos.y / GRID_UNIT),
	)


func _is_grid_valid(grid_pos: Vector2i) -> bool:
	if grid_pos.x < 0 or grid_pos.y < 0 or grid_pos.x >= MAP_SIZE.x or grid_pos.y >= MAP_SIZE.y:
		return false

	var track_cells := _get_track_cells()
	var tile_x := grid_pos.x * 2
	var tile_y := grid_pos.y * 2
	for tx in range(tile_x, tile_x + 2):
		for ty in range(tile_y, tile_y + 2):
			if track_cells.has(Vector2i(tx, ty)):
				return false

	if _occupied_cells.has(grid_pos):
		return false

	return true


func _try_place_tower() -> void:
	var grid_pos := _mouse_to_grid()
	if not _is_grid_valid(grid_pos):
		return
	if not GameState.spend_coins(_selected_tower_cost):
		return

	var tower := _selected_tower_scene.instantiate()
	tower.position = Vector2(grid_pos) * GRID_UNIT + HALF_GRID
	tower.cost = _selected_tower_cost
	tower.add_to_group("towers")
	add_child(tower)
	_occupied_cells.append(grid_pos)
	_clear_selection()


func _on_tower_selected(scene_path: String, cost: int) -> void:
	_clear_selection()
	_selected_tower_scene = load(scene_path)
	_selected_tower_cost = cost
	_preview = _selected_tower_scene.instantiate()
	_preview.modulate.a = 0.5
	_preview.process_mode = PROCESS_MODE_DISABLED
	add_child(_preview)


func _on_selection_cancelled() -> void:
	_clear_selection()


func _clear_selection() -> void:
	if _preview:
		_preview.queue_free()
		_preview = null
	_selected_tower_scene = null
	_hide_tower_menu()


func _create_tower_menu() -> void:
	_tower_menu = Control.new()
	_tower_menu.z_index = 100
	_tower_menu.hide()

	var panel := PanelContainer.new()
	_tower_menu.add_child(panel)

	var vbox := VBoxContainer.new()
	panel.add_child(vbox)

	_sell_btn = Button.new()
	_sell_btn.text = "Sell"
	_sell_btn.pressed.connect(_on_sell_pressed)
	vbox.add_child(_sell_btn)

	add_child(_tower_menu)


func _try_select_tower() -> void:
	var mouse_pos := get_global_mouse_position()
	var towers := get_tree().get_nodes_in_group("towers")
	var closest: Node2D = null
	var closest_dist := 48.0
	for tower in towers:
		var dist := mouse_pos.distance_to(tower.position)
		if dist < closest_dist:
			closest = tower
			closest_dist = dist

	if closest:
		_selected_tower = closest
		_tower_menu.position = closest.position - Vector2(0, 64)

		for btn in _upgrade_btns:
			btn.queue_free()
		_upgrade_btns.clear()

		var upgrades: Array = UPGRADES.get(closest.scene_file_path, [])
		var can_upgrade := GameState.current_level > 2 or GameState.current_level == 0
		if not upgrades.is_empty() and can_upgrade:
			var vbox: VBoxContainer = _tower_menu.get_child(0).get_child(0)
			for upgrade in upgrades:
				var btn := Button.new()
				btn.text = "Upgrade: %s - %d" % [upgrade.name, upgrade.cost]
				btn.pressed.connect(_on_upgrade_pressed.bind(upgrade))
				vbox.add_child(btn)
				vbox.move_child(btn, vbox.get_child_count() - 2)
				_upgrade_btns.append(btn)

		_tower_menu.show()
	else:
		_hide_tower_menu()


func _hide_tower_menu() -> void:
	_selected_tower = null
	_tower_menu.hide()


func _on_sell_pressed() -> void:
	if not _selected_tower:
		return
	var refund := floori(_selected_tower.cost * 0.9)
	GameState.add_coins(refund)
	var grid_pos := Vector2i(
		floori((_selected_tower.position.x - HALF_GRID.x) / GRID_UNIT),
		floori((_selected_tower.position.y - HALF_GRID.y) / GRID_UNIT),
	)
	_occupied_cells.erase(grid_pos)
	_selected_tower.queue_free()
	_hide_tower_menu()


func _on_upgrade_pressed(upgrade: Dictionary) -> void:
	if not _selected_tower:
		return
	if not GameState.spend_coins(upgrade.cost):
		return

	var packed: PackedScene = load(upgrade.scene)
	var new_tower: Node2D = packed.instantiate()
	new_tower.position = _selected_tower.position
	new_tower.cost = _selected_tower.cost + upgrade.cost
	new_tower.add_to_group("towers")
	add_child(new_tower)
	_selected_tower.queue_free()
	_hide_tower_menu()


func _get_track_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for i in range(TRACK_GRID.size() - 1):
		var from_pos := TRACK_GRID[i]
		var to_pos := TRACK_GRID[i + 1]

		var min_x = min(from_pos.x, to_pos.x)
		var max_x = max(from_pos.x, to_pos.x)
		var min_y = min(from_pos.y, to_pos.y)
		var max_y = max(from_pos.y, to_pos.y)

		for tx in range(min_x * 2, max_x * 2 + 2):
			for ty in range(min_y * 2, max_y * 2 + 2):
				var cell = Vector2i(tx, ty)
				if not cells.has(cell):
					cells.append(cell)
	return cells


func _setup_tilemap() -> void:
	$GrassTileMap.clear()
	$DirtTileMap.clear()

	var track_cells := _get_track_cells()
	var grass_cells: Array[Vector2i] = []

	var tile_range_x := MAP_SIZE.x * 2
	var tile_range_y := MAP_SIZE.y * 2

	for x in range(tile_range_x):
		for y in range(tile_range_y):
			var cell = Vector2i(x, y)
			if not track_cells.has(cell):
				grass_cells.append(cell)

	$GrassTileMap.set_cells_terrain_connect(grass_cells, 0, 0, false)
	$DirtTileMap.set_cells_terrain_connect(track_cells, 0, 1, false)


func _setup_path() -> void:
	var track_points := PackedVector2Array()
	for grid_pos in TRACK_GRID:
		track_points.append(Vector2(grid_pos) * GRID_UNIT + HALF_GRID)

	var curve := Curve2D.new()
	for point in track_points:
		curve.add_point(point)

	$Path.curve = curve


func _check_wave_completion() -> void:
	if not GameState.is_wave_active:
		return
	if _spawn_queue.is_empty() and GameState.mobs_alive <= 0:
		GameState.is_wave_active = false
		GameState.wave_completed.emit()
		var level_waves := GameState.get_waves(GameState.current_level)
		if GameState.wave_number >= level_waves.size():
			GameState.level_completed.emit(GameState.current_level)


func _on_level_completed(_level: int) -> void:
	GameState.unlock_next_level()
	var victory_scene := preload("res://ui/victory.tscn")
	var victory := victory_scene.instantiate()
	add_child(victory)
	get_tree().paused = true


func _on_game_over() -> void:
	var defeat_scene := preload("res://ui/lose.tscn")
	var defeat := defeat_scene.instantiate()
	add_child(defeat)
	get_tree().paused = true


func start_wave() -> void:
	var wave: Dictionary = GameState.get_wave(GameState.current_level, GameState.wave_number)
	_spawn_queue.clear()
	for group in wave.groups:
		for j in range(group.count):
			_spawn_queue.append(group.max_rgb)

	GameState.wave_number += 1
	GameState.is_wave_active = true
	_spawn_timer.wait_time = wave.interval
	_spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	if _spawn_queue.is_empty():
		_spawn_timer.stop()
		_check_wave_completion()
		return
	var max_rgb: Vector3 = _spawn_queue.pop_front()
	_spawn_mob(max_rgb)


func _spawn_mob(max_rgb: Vector3) -> void:
	var mob := _mob_scene.instantiate()
	mob.max_rgb = max_rgb
	$Path.add_child(mob)
