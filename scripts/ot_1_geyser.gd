extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_subgroup("Forces")
@export var BEETLE_FORCE_VECTOR: Vector2 = Vector2(0.0, 300.0)
@export var DUNG_FORCE_VECTOR: Vector2 = Vector2(0.0, 2.5)

@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D

var dung_close: bool
var beetle_close: bool
var rng = RandomNumberGenerator.new()
var force_x: float


func _physics_process(delta: float) -> void:
	if beetle_close && (animated_sprite_2d.frame >= 6 && animated_sprite_2d.frame <= 9):
		BEETLE_FORCE_VECTOR.x += rng.randf_range(-5.0, 5.0)
		beetle.velocity -= BEETLE_FORCE_VECTOR
	if dung_close && (animated_sprite_2d.frame >= 6 && animated_sprite_2d.frame <= 9):
		DUNG_FORCE_VECTOR.x += rng.randf_range(-0.1, 0.1)
		dung_ball.apply_impulse(-DUNG_FORCE_VECTOR, Vector2.ZERO)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == dung_ball:
		dung_close = true
	if body == beetle:
		beetle_close = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == dung_ball:
		dung_close = false
	if body == beetle:
		beetle_close = false


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("eject")
