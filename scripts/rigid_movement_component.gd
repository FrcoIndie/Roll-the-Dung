class_name RigidMovementComponent
extends Node2D


const IMPULSE: float = 0.25
const MAX_SPEED: float = 200.0

var velocity = Vector2.ZERO


func beetle_movement(body: RigidBody2D, direction: float, delta: float):
	if body.on_floor || body.over_dung:
		velocity.x = direction * IMPULSE
		body.apply_central_impulse(velocity)
		if body.linear_velocity.length() > MAX_SPEED:
			body.linear_velocity = body.linear_velocity.normalized() * MAX_SPEED
