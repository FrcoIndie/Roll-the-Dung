extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var snore_1 = $snore1
@onready var snore_2 = $snore2

@export_subgroup("Forces")
@export var FORCE_VECTOR: Vector2 = Vector2(0.5, 0.75)

@export_subgroup("Bodies")
@export var beetle: RigidBody2D
@export var dung_ball: RigidBody2D

var beetle_in_area: bool = false
var dung_in_area: bool = false
var time_to_snore: bool = false


func _physics_process(delta: float) -> void:
	if animated_sprite_2d.animation == "move" && animated_sprite_2d.frame < 3:
		if beetle_in_area:
			beetle.apply_central_impulse(-FORCE_VECTOR)
		if dung_in_area:
			dung_ball.apply_central_impulse(-FORCE_VECTOR)


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


func _on_timer_2_timeout():
	if time_to_snore:
		snore_1.play()
	else:
		snore_2.play()
	!time_to_snore
