extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_subgroup("Forces")
@export var BEETLE_FORCE_VECTOR: Vector2 = Vector2(0.0, 300.0)
@export var DUNG_FORCE_VECTOR: Vector2 = Vector2(0.0, 2.5)

@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D

var dung_in: bool
var beetle_in: bool
var rng = RandomNumberGenerator.new()
var force_x: float


func _physics_process(delta: float) -> void:
	if beetle_in:
		BEETLE_FORCE_VECTOR.y += rng.randf_range(-5.5, 5.5)
		beetle.velocity -= BEETLE_FORCE_VECTOR
	if dung_in:
		DUNG_FORCE_VECTOR.y += rng.randf_range(-5.5, 5.0)
		dung_ball.apply_impulse(-DUNG_FORCE_VECTOR, Vector2.ZERO)

func _on_push_area_body_entered(body: Node2D) -> void:
	if body == dung_ball:
		dung_in = true
	if body == beetle:
		beetle_in = true


func _on_push_area_body_exited(body: Node2D) -> void:
	if body == dung_ball:
		dung_in = false
	if body == beetle:
		beetle_in = false
