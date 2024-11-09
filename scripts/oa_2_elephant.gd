extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_subgroup("Forces")
@export var BEETLE_FORCE_VECTOR: Vector2
@export var DUNG_FORCE_VECTOR: Vector2

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
	
	handle_distance()
	walk()


func handle_distance() -> void:
	if beetle_distance > MAX_DISTANCE:
		BEETLE_FORCE_VECTOR = Vector2.ZERO
	else:
		var t: float = beetle_distance / MAX_DISTANCE
		BEETLE_FORCE_VECTOR = MIN_BEETLE_FORCE.lerp(MAX_BEETLE_FORCE, 1.0 - t)
	
	if dung_distance > MAX_DISTANCE:
		DUNG_FORCE_VECTOR = Vector2.ZERO
	else:
		var t: float = dung_distance / MAX_DISTANCE
		DUNG_FORCE_VECTOR = MIN_DUNG_FORCE.lerp(MAX_DUNG_FORCE, 1.0 - t)


func walk() -> void:
	if previous_frame == 0 && current_frame == 1:
		if beetle.is_on_floor():
			beetle.velocity -= BEETLE_FORCE_VECTOR
		if dung_ball.on_ground:
			dung_ball.apply_impulse(-DUNG_FORCE_VECTOR, Vector2.ZERO)
	previous_frame = animated_sprite_2d.frame
