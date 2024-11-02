extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var DUNG_FORCE_VECTOR: Vector2 = Vector2(0.0, 100.0)
@export var BEETLE_FORCE_VECTOR: Vector2 = Vector2(0.0, 50.0)


@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D

var dung_close: bool
var beetle_close: bool
var rng = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	eject()


func eject() -> void:
	if dung_close && animated_sprite_2d.frame == 3:
		DUNG_FORCE_VECTOR.x = rng.randf_range(-5.0, 5.0)
		dung_ball.linear_velocity -= DUNG_FORCE_VECTOR
	if beetle_close && animated_sprite_2d.frame == 3:
		BEETLE_FORCE_VECTOR.x = rng.randf_range(-5.0, 5.0) 
		beetle.velocity -= BEETLE_FORCE_VECTOR


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
	animated_sprite_2d.play("default")
