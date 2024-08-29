class_name ForcesComponent
extends Node2D


func beetle_forces(body: CharacterBody2D, force: float):
	for i in body.get_slide_collision_count():
		var c = body.get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * force)
