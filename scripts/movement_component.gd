class_name MovementComponent
extends Node2D


@export_subgroup("Settings")
@export var max_speed: float = 250.0
@export var accel: float = 20.0
@export var decel: float = 20.0
@export var fall_decel: float = 0.0
@export var floor_snap_length: float = 7.0

const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH


func beetle_movement(body: CharacterBody2D, method: String, direction: float, delta: float) -> void:
	var speed: float = 0.0
	var vel_change_speed: float = 0.0
	
	body.floor_snap_length = floor_snap_length
	
	match method:
		"accel":
			vel_change_speed = accel
			speed = direction * max_speed
		"decel":
			vel_change_speed = decel
			speed = 0.0
		"fall":
			vel_change_speed = fall_decel
			speed = body.velocity.x
	
	body.velocity.x = move_toward(body.velocity.x, speed, vel_change_speed)
