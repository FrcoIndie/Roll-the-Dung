class_name ForcesComponent
extends Node2D


@export_subgroup("Settings")
@export var push_force: float = 10.0


func beetle_forces(body: CharacterBody2D):
	for i in body.get_slide_collision_count():
		var c = body.get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
