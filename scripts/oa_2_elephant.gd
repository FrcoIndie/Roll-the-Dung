extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var step_1 = $step_1
@onready var step_2 = $step_2
@onready var step_3 = $step_3
@onready var step_4 = $step_4

const MIN_BEETLE_FORCE_VECTOR: Vector2 = Vector2(0.0, 2.0)
const MAX_BEETLE_FORCE_VECTOR: Vector2 = Vector2(0.0, 6.0)
const MIN_DUNG_FORCE_VECTOR: Vector2 = Vector2(0.0, 5.0)
const MAX_DUNG_FORCE_VECTOR: Vector2 = Vector2(0.0, 10.0)

@export var MAX_DISTANCE: float = 1000.0

@export_subgroup("Bodies")
@export var beetle: RigidBody2D
@export var dung_ball: RigidBody2D

var beetle_distance: float
var dung_distance: float
var previous_frame: int
var current_frame: int
var track: int = 1

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
		return MIN_BEETLE_FORCE_VECTOR.lerp(MAX_BEETLE_FORCE_VECTOR, 1.0 - t)

func handle_dung_distance() -> Vector2:
	if dung_distance > MAX_DISTANCE:
		return Vector2.ZERO
	else:
		var t: float = dung_distance / MAX_DISTANCE
		return MIN_DUNG_FORCE_VECTOR.lerp(MAX_DUNG_FORCE_VECTOR, 1.0 - t)


func walk(beetle_force_vector, dung_force_vector) -> void:
	if previous_frame == 0 && current_frame == 1:
		if beetle.on_floor:
			beetle.apply_central_impulse(-beetle_force_vector)
		if dung_ball.on_ground:
			dung_ball.apply_central_impulse(-dung_force_vector)
	previous_frame = animated_sprite_2d.frame


func _on_timer_timeout():
	if track == 1:
		step_1.play()
	elif track == 1:
		step_2.play()
	elif track == 1:
		step_3.play()
	elif track == 1:
		step_4.play()
	track += 1
	if track > 4:
		track = 1
