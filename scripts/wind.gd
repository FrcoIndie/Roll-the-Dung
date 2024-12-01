extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_subgroup("Forces")
@export var FORCE_VECTOR: Vector2 = Vector2(8.0, 0.0)

@export_subgroup("Bodies")
@export var beetle: RigidBody2D
@export var dung_ball: RigidBody2D

var dung_in: bool
var beetle_in: bool
var rng = RandomNumberGenerator.new()
var force_x: float


func _physics_process(delta: float) -> void:
	pass


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


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("breeze")
	if beetle_in:
		beetle.apply_central_impulse(-FORCE_VECTOR)
	if dung_in:
		dung_ball.apply_central_impulse(-FORCE_VECTOR)
