class_name MovementComponent
extends Node2D


@export_subgroup("Settings")
@export var max_speed: float = 450.0
@export var accel: float = 20.0
@export var decel: float = 15.0
@export var roll_decel: float = 1.0
@export var fall_decel: float = 0.0


func beetle_movement(body: CharacterBody2D, method: String, direction: Vector2, delta: float) -> void:
	var speed: float = 0.0
	var vel_change_speed: float = 0.0
	
	match method:
		"accel":
			vel_change_speed = accel
			speed = direction.x * max_speed
		"decel":
			vel_change_speed = decel
			speed = 0.0
		"roll":
			vel_change_speed = roll_decel
			speed = 0.0
		"fall":
			vel_change_speed = fall_decel
			speed = body.velocity.x
	
	body.velocity.x = move_toward(body.velocity.x, speed, vel_change_speed)
