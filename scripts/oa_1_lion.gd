extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export_subgroup("Bodies")
@export var beetle: CharacterBody2D
@export var dung_ball: RigidBody2D
@export var BASE_FORCE_VECTOR: Vector2 = Vector2(0.0, -50.0)

var in_area: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animated_sprite_2d.animation == "move":
		if in_area && animated_sprite_2d.frame < 3:
			dung_ball.linear_velocity.y -= 25


func _on_timer_timeout() -> void:
	tail_movement()


func tail_movement() -> void:
	animated_sprite_2d.play("move")


func _on_animated_sprite_2d_obstacle_animation_finished() -> void:
	animated_sprite_2d.play("wait")


func _on_area_2d_body_entered(body) -> void:
	if body == dung_ball:
		in_area = true


func _on_area_2d_body_exited(body) -> void:
	if body == dung_ball:
		in_area = false
