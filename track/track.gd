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


func _ready() -> void:
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

	GameState.wave_completed.connect(_on_wave_completed)
	GameState.start_wave_pressed.connect(start_wave)


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
			and _preview
	):
		return
	_try_place_tower()


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed):
		return
	match event.keycode:
		KEY_R:
			_on_tower_selected("res://tower/warrior/warrior.tscn", 25)
		KEY_G:
			_on_tower_selected("res://tower/archer/archer.tscn", 50)
		KEY_B:
			_on_tower_selected("res://tower/mage/mage.tscn", 75)
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


func _on_wave_completed() -> void:
	pass


func start_wave() -> void:
	var wave: Dictionary = GameState.get_wave(GameState.wave_number)
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
		return
	var max_rgb: Vector3 = _spawn_queue.pop_front()
	_spawn_mob(max_rgb)


func _spawn_mob(max_rgb: Vector3) -> void:
	var mob := _mob_scene.instantiate()
	mob.max_rgb = max_rgb
	$Path.add_child(mob)
