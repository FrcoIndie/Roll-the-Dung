class_name ForcesComponent
extends Node2D


var flag_forces: bool = false


func beetle_forces(body: CharacterBody2D, force: float):
	if flag_forces:
		for i in body.get_slide_collision_count():
			var collision = body.get_slide_collision(i)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * force)
