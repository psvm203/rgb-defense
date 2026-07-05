extends Node2D

@export var attack_range: float
@export var attack_cooldown: float
@export var damage: float

var _color_index: int
var _tower_color: Color
var _projectile_color: Color
var _attack_frame: int = 3
var _time_since_attack: float = 0.0
var _target: Area2D
var _base_sprite_x: float
var _projectile_scene: PackedScene
var _target_locked: bool = false
var cost: int = 0


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


func _process(delta: float) -> void:
	_time_since_attack += delta
	_find_target()
	if _target and _time_since_attack >= attack_cooldown:
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
	_time_since_attack = 0.0
	if not is_instance_valid(_target):
		_target = null
		return
	_target_locked = true
	var is_flipped := _target.global_position.x < global_position.x
	$AnimatedSprite2D.flip_h = is_flipped
	$AnimatedSprite2D.position.x = -_base_sprite_x if is_flipped else _base_sprite_x
	$AnimatedSprite2D.play("attack")


func _on_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == _attack_frame:
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
	if $AnimatedSprite2D.animation == "attack":
		_target_locked = false
		$AnimatedSprite2D.play("default")


func _draw() -> void:
	draw_rect(Rect2(-16, -16, 32, 32), _tower_color)
	draw_circle(Vector2.ZERO, attack_range, Color(_tower_color, 0.1))
