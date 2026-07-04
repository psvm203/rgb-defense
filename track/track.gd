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


func _ready() -> void:
	set_process_input(true)
	_setup_tilemap()
	_setup_path()
	_spawn_mob()


func _input(event: InputEvent) -> void:
	if not (
			event is InputEventMouseButton
			and event.pressed
			and event.button_index == MOUSE_BUTTON_LEFT
	):
		return
	_place_tower()


func _place_tower() -> void:
	var world_pos := get_global_mouse_position()
	var grid_pos := Vector2i(
		roundi(world_pos.x / GRID_UNIT),
		roundi(world_pos.y / GRID_UNIT),
	)
	if grid_pos.x < 0 or grid_pos.y < 0 or grid_pos.x >= MAP_SIZE.x or grid_pos.y >= MAP_SIZE.y:
		return

	var track_cells := _get_track_cells()
	var tile_x := grid_pos.x * 2
	var tile_y := grid_pos.y * 2
	for tx in range(tile_x, tile_x + 2):
		for ty in range(tile_y, tile_y + 2):
			if track_cells.has(Vector2i(tx, ty)):
				return

	var tower_scene := preload("res://tower/archer.tscn")
	var tower := tower_scene.instantiate()
	tower.position = Vector2(grid_pos) * GRID_UNIT + HALF_GRID
	add_child(tower)


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
	$TileMap.clear()

	var track_cells := _get_track_cells()
	var grass_cells: Array[Vector2i] = []

	var tile_range_x := MAP_SIZE.x * 2
	var tile_range_y := MAP_SIZE.y * 2

	for x in range(tile_range_x):
		for y in range(tile_range_y):
			var cell = Vector2i(x, y)
			if not track_cells.has(cell):
				grass_cells.append(cell)

	$TileMap.set_cells_terrain_connect(grass_cells, 0, 0, false)


func _setup_path() -> void:
	var track_points := PackedVector2Array()
	for grid_pos in TRACK_GRID:
		track_points.append(Vector2(grid_pos) * GRID_UNIT + HALF_GRID)

	var curve := Curve2D.new()
	for point in track_points:
		curve.add_point(point)

	$Path.curve = curve


func _spawn_mob() -> void:
	var mob_scene := preload("res://mob/mob.tscn")
	var mob := mob_scene.instantiate()
	$Path/SpawnPoint.add_child(mob)
