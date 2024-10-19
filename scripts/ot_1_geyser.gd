extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var BASE_FORCE_VECTOR: Vector2 = Vector2(0.0, 100.0)
@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D

var dung_close: bool


func _process(delta: float) -> void:
	eject()


func eject() -> void:
	if dung_close && animated_sprite_2d.frame == 3:
		dung_ball.linear_velocity -= BASE_FORCE_VECTOR


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == dung_ball:
		dung_close = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == dung_ball:
		dung_close = false


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("default")
