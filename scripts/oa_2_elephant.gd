extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_subgroup("Movement")
@export var MOV_VEL: Vector2 = Vector2(0.5, 0.0)
@export_subgroup("Forces")
@export var BASE_FORCE_VECTOR: Vector2
@export var MIN_FORCE: Vector2 = Vector2(0.0, 300.0)
@export var MAX_FORCE: Vector2 = Vector2(0.0, 600.0)
@export var MAX_DISTANCE: float = 1200.0
@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D


var distance: float
var dung_close: bool
var previous_frame: int
var current_frame: int


func _process(delta: float) -> void:
	distance = abs(position.x - dung_ball.position.x)
	current_frame = animated_sprite_2d.frame
	
	handle_distance()
	walk()


func handle_distance() -> void:
	if distance > MAX_DISTANCE:
		BASE_FORCE_VECTOR = Vector2.ZERO
	else:
		var t: float = distance / MAX_DISTANCE
		BASE_FORCE_VECTOR = MIN_FORCE.lerp(MAX_FORCE, 1.0 - t)


func walk() -> void:
	position -= MOV_VEL
	if previous_frame == 0 && current_frame == 1:
		dung_ball.linear_velocity -= BASE_FORCE_VECTOR
	previous_frame = animated_sprite_2d.frame
