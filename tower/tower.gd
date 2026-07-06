extends Node2D

const WARRIOR_COST := 25
const ARCHER_COST := 50
const MAGE_COST := 75

@export var attack_range: float
@export var damage: float

var _color_index: int
var _tower_color: Color
var _projectile_color: Color
var _attack_frame: int = 3
var _target: Area2D
var _base_sprite_x: float
var _projectile_scene: PackedScene
var _projectile_speed: float = 300.0
var _projectile_texture: Texture2D
var _projectile_scale: float = 1.0
var _projectile_acceleration: float = 0.0
var _projectile_homing_duration: float = 0.0
var _projectile_afterimage_interval: float = 0.0
var _target_locked: bool = false
var cost: int = 0
var _show_range := false


func set_show_range(show: bool) -> void:
	_show_range = show
	queue_redraw()


func _ready() -> void:
	_base_sprite_x = $AnimatedSprite2D.position.x
	_projectile_scene = preload("res://tower/projectile.tscn")
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$AnimatedSprite2D.frame_changed.connect(_on_frame_changed)
	_setup_tower()
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.position.x = -_base_sprite_x


func _setup_tower() -> void:
	pass


func _process(_delta: float) -> void:
	_find_target()
	if _target and $AnimatedSprite2D.animation == "default":
		_attack()


func _find_target() -> void:
	if _target_locked:
		return
	var mobs := get_tree().get_nodes_in_group("mobs")

	var closest: Area2D = null
	var closest_dist := INF
	for mob in mobs:
		if mob.rgb[_color_index] <= 0.0:
			continue
		var dist := global_position.distance_to(mob.global_position)
		if dist <= attack_range and dist < closest_dist:
			closest = mob
			closest_dist = dist

	if closest:
		_target = closest
		return

	var best: Area2D = null
	var best_progress: float = -1.0
	for mob in mobs:
		if mob.rgb == Vector3.ZERO:
			continue
		var dist := global_position.distance_to(mob.global_position)
		if dist <= attack_range and mob.get_traveled() > best_progress:
			best = mob
			best_progress = mob.get_traveled()

	_target = best


func _attack() -> void:
	if not is_instance_valid(_target):
		_target = null
		return
	_target_locked = true
	var is_flipped := _target.global_position.x < global_position.x
	$AnimatedSprite2D.flip_h = is_flipped
	$AnimatedSprite2D.position.x = -_base_sprite_x if is_flipped else _base_sprite_x
	$AnimatedSprite2D.play("attack")


func _on_frame_changed() -> void:
	if $AnimatedSprite2D.animation != "default" and $AnimatedSprite2D.frame == _attack_frame:
		if is_instance_valid(_target):
			_perform_attack()


func _perform_attack() -> void:
	pass


func _spawn_projectile(
		splash_radius: float = 0.0,
		pierce_count: int = 0,
		slow_duration: float = 0.0,
		slow_factor: float = 1.0,
		chain_count: int = 0,
		chain_radius: float = 0.0,
) -> void:
	var projectile := _projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.speed = _projectile_speed
	if _projectile_texture:
		projectile.set_texture(_projectile_texture)
		projectile.set_texture_scale(_projectile_scale)
		projectile.set_homing_duration(_projectile_homing_duration)
		projectile.set_acceleration(_projectile_acceleration)
		projectile.set_afterimage(_projectile_afterimage_interval)
	projectile.setup(
		_target,
		damage,
		_color_index,
		_projectile_color,
		splash_radius,
		pierce_count,
		slow_duration,
		slow_factor,
		chain_count,
		chain_radius,
	)


func _on_animation_finished() -> void:
	if $AnimatedSprite2D.animation != "default":
		_target_locked = false
		$AnimatedSprite2D.play("default")


func _draw() -> void:
	if _show_range:
		draw_arc(Vector2.ZERO, attack_range, 0, TAU, 64, _tower_color, 2.0)
