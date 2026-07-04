extends Node2D

@export var attack_range: float = 200.0
@export var attack_cooldown: float = 1.5
@export var damage: float = 0.2

const COLOR_INDEX := 1
const PROJECTILE_COLOR := Color(0.2, 1.0, 0.2)
const TOWER_COLOR := Color(0.2, 1.0, 0.2)

var _time_since_attack: float = 0.0
var _target: Area2D
var _base_sprite_x: float
var _projectile_scene: PackedScene


func _ready() -> void:
	_base_sprite_x = $AnimatedSprite2D.position.x
	_projectile_scene = preload("res://tower/projectile.tscn")
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$AnimatedSprite2D.frame_changed.connect(_on_frame_changed)


func _process(delta: float) -> void:
	_time_since_attack += delta
	_find_target()
	_update_flip()
	if _target and _time_since_attack >= attack_cooldown:
		_attack()


func _find_target() -> void:
	var mobs := get_tree().get_nodes_in_group("mobs")
	var closest: Area2D = null
	var closest_dist := INF

	for mob in mobs:
		if mob.rgb.y <= 0.0:
			continue
		var dist := global_position.distance_to(mob.global_position)
		if dist <= attack_range and dist < closest_dist:
			closest = mob
			closest_dist = dist

	_target = closest


func _update_flip() -> void:
	if not is_instance_valid(_target):
		return
	var is_flipped := _target.global_position.x < global_position.x
	$AnimatedSprite2D.flip_h = is_flipped
	$AnimatedSprite2D.position.x = -_base_sprite_x if is_flipped else _base_sprite_x


func _attack() -> void:
	_time_since_attack = 0.0
	if not is_instance_valid(_target):
		_target = null
		return
	$AnimatedSprite2D.play("attack")


func _on_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 3:
		if is_instance_valid(_target):
			_spawn_projectile()


func _spawn_projectile() -> void:
	var projectile := _projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.setup(_target, damage, COLOR_INDEX, PROJECTILE_COLOR)


func _on_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		$AnimatedSprite2D.play("default")


func _draw() -> void:
	draw_rect(Rect2(-16, -16, 32, 32), TOWER_COLOR)
	draw_circle(Vector2.ZERO, attack_range, Color(TOWER_COLOR, 0.1))
