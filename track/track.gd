extends Node2D

const GRID_UNIT: int = 72


func _ready() -> void:
	var track_grid: Array[Vector2] = [
		Vector2(0, 4), # entry
		Vector2(4, 4),
		Vector2(4, 2),
		Vector2(8, 2),
		Vector2(8, 4),
		Vector2(6, 4),
		Vector2(6, 6),
		Vector2(10, 6),
		Vector2(10, 2),
		Vector2(12, 2),
		Vector2(12, 8), # exit
	]

	var track_points := PackedVector2Array()
	for grid_pos in track_grid:
		track_points.append(grid_pos * GRID_UNIT)

	var curve := Curve2D.new()
	for point in track_points:
		curve.add_point(point)

	$Track.curve = curve
	$TrackLine.points = track_points
	$TrackLine.width = 40.0
	$TrackLine.default_color = Color(0.35, 0.35, 0.35)
