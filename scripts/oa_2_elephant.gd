extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var step_1 = $step_1
@onready var step_2 = $step_2
@onready var step_3 = $step_3
@onready var step_4 = $step_4

const BEETLE_FORCE_VECTOR: Vector2 = Vector2(0.0, 2.5)
const DUNG_FORCE_VECTOR: Vector2 = Vector2(0.0, 25.0)

@export_subgroup("Bodies")
@export var beetle: RigidBody2D
@export var dung_ball: RigidBody2D

var beetle_in: bool
var dung_in: bool
var previous_frame: int
var current_frame: int
var track: int = 1


func _physics_process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("Beetle"):
		beetle_in = true
	if body.is_in_group("Dung Ball"):
		dung_in = true

func _on_area_2d_body_exited(body: RigidBody2D) -> void:
	if body.is_in_group("Beetle"):
		beetle_in = false
	if body.is_in_group("Dung Ball"):
		dung_in = false


func _on_timer_timeout():
	if beetle_in && beetle.on_floor:
		beetle.apply_central_impulse(-BEETLE_FORCE_VECTOR)
	if dung_in && dung_ball.on_ground:
		dung_ball.apply_central_impulse(-DUNG_FORCE_VECTOR)
	
	if track == 1:
		step_1.play()
	elif track == 1:
		step_2.play()
	elif track == 1:
		step_3.play()
	elif track == 1:
		step_4.play()
	track += 1
	if track > 4:
		track = 1
