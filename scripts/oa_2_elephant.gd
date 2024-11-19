extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MIN_BEETLE_FORCE: Vector2 = Vector2(0.0, 300.0)
const MAX_BEETLE_FORCE: Vector2 = Vector2(0.0, 600.0)
const MIN_DUNG_FORCE: Vector2 = Vector2(0.0, 0.2)
const MAX_DUNG_FORCE: Vector2 = Vector2(0.0, 0.6)

@export var MAX_DISTANCE: float = 1000.0

@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D

var beetle_distance: float
var dung_distance: float
var previous_frame: int
var current_frame: int


func _physics_process(delta: float) -> void:
	beetle_distance = abs(position.x - beetle.position.x)
	dung_distance = abs(position.x - dung_ball.position.x)
	current_frame = animated_sprite_2d.frame
	
	var beetle_force_vector = handle_beetle_distance()
	var dung_force_vector = handle_dung_distance()
	walk(beetle_force_vector, dung_force_vector)


func handle_beetle_distance() -> Vector2:
	if beetle_distance > MAX_DISTANCE:
		return Vector2.ZERO
	else:
		var t: float = beetle_distance / MAX_DISTANCE
		return MIN_BEETLE_FORCE.lerp(MAX_BEETLE_FORCE, 1.0 - t)

func handle_dung_distance() -> Vector2:
	if dung_distance > MAX_DISTANCE:
		return Vector2.ZERO
	else:
		var t: float = dung_distance / MAX_DISTANCE
		return MIN_DUNG_FORCE.lerp(MAX_DUNG_FORCE, 1.0 - t)


func walk(beetle_force_vector, dung_force_vector) -> void:
	if previous_frame == 0 && current_frame == 1:
		if beetle.is_on_floor():
			beetle.velocity -= beetle_force_vector
		if dung_ball.on_ground:
			dung_ball.apply_impulse(-dung_force_vector, Vector2.ZERO)
	previous_frame = animated_sprite_2d.frame
