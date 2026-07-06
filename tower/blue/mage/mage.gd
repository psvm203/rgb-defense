extends "res://tower/tower.gd"

@export var splash_radius: float = 80.0

const FRAME_COUNT := 8
const FRAME_SIZE := 32


func _setup_tower() -> void:
	attack_range = 180.0
	$AnimatedSprite2D.speed_scale = 0.5
	damage = 15
	_color_index = 2
	_tower_color = Color(0.2, 0.2, 1.0)
	_projectile_color = Color(0.2, 0.2, 1.0)
	_projectile_homing_duration = 0.25
	_attack_frame = 6
	_projectile_fps = 10.0
	_projectile_speed = 600.0
	_setup_projectile_frames()


func _setup_projectile_frames() -> void:
	var sheet: Texture2D = load("res://tower/blue/mage/magic/magic_projectile.png")
	if sheet == null:
		return
	var frames: Array[Texture2D] = []
	for i in range(FRAME_COUNT):
		var frame := AtlasTexture.new()
		frame.atlas = sheet
		frame.region = Rect2(i * FRAME_SIZE, 0, FRAME_SIZE, FRAME_SIZE)
		frames.append(frame)
	_projectile_frames = frames


func _perform_attack() -> void:
	SfxPlayer.play("magic")
	_spawn_projectile(splash_radius)
