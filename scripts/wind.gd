extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var blow = $blow

@export_subgroup("Forces")
@export var FORCE_VECTOR: Vector2 = Vector2(8.0, 0.0)

@export_subgroup("Bodies")
@export var beetle: RigidBody2D
@export var dung_ball: RigidBody2D

var dung_in: bool
var beetle_in: bool
var rng = RandomNumberGenerator.new()
var force_x: float
var bettle_pulled: bool = false
var dung_ball_pulled: bool = false

func _physics_process(delta: float) -> void:
	if animated_sprite_2d.is_playing():
		if beetle_in and !bettle_pulled:
			beetle.apply_central_impulse(-FORCE_VECTOR)
			bettle_pulled = true
		if dung_in and !dung_ball_pulled:
			dung_ball.apply_central_impulse(-FORCE_VECTOR)
			dung_ball_pulled = true


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
	bettle_pulled = false
	dung_ball_pulled = false
	animated_sprite_2d.play("breeze")
	blow.play()
	blow.volume_db = 20.0
	var tween = create_tween()
	tween.tween_property(blow, "volume_db", -80.0, 3.2)
