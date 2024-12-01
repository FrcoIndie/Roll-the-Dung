class_name RigidMovementComponent
extends Node2D


const IMPULSE: float = 1.0
const MAX_SPEED: float = 200.0

var velocity = Vector2.ZERO


func beetle_movement(body: RigidBody2D, direction: float, delta: float):
	if body.on_floor || body.over_dung:
		var slope_angle = body.slope_angle # Vector // a la pendiente
		var slope_direction = Vector2(cos(slope_angle), -sin(slope_angle)).normalized()
		
		velocity = slope_direction * direction * IMPULSE
		
		body.apply_central_impulse(velocity)
		
		if abs(body.linear_velocity.x) > MAX_SPEED:
			body.linear_velocity.x = sign(body.linear_velocity.x) * MAX_SPEED
