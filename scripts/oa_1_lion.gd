extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export_subgroup("Forces")
@export var BEETLE_FORCE_VECTOR: Vector2 = Vector2(15.0, 45.0)
@export var DUNG_FORCE_VECTOR: Vector2 = Vector2(0.25, 1.0)

@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D

var beetle_in_area: bool = false
var dung_in_area: bool = false


func _physics_process(delta: float) -> void:
	if animated_sprite_2d.animation == "move" && animated_sprite_2d.frame < 3:
		if beetle_in_area:
			beetle.velocity -= BEETLE_FORCE_VECTOR
		if dung_in_area:
			dung_ball.apply_impulse(-DUNG_FORCE_VECTOR, Vector2.ZERO)


func _on_timer_timeout() -> void:
	tail_movement()


func tail_movement() -> void:
	animated_sprite_2d.play("move")

func _on_animated_sprite_2d_obstacle_animation_finished() -> void:
	animated_sprite_2d.play("wait")


func _on_area_2d_body_entered(body) -> void:
	if body == beetle:
		beetle_in_area = true
	if body == dung_ball:
		dung_in_area = true

func _on_area_2d_body_exited(body) -> void:
	if body == beetle:
		beetle_in_area = false
	if body == dung_ball:
		dung_in_area = false
