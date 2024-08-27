class_name RollComponent
extends Node2D


func handle_roll(body: CharacterBody2D, direction: Vector2) -> void:
	if direction.y > 0.0:
		#body.z_index = 1
		body.set_collision_layer_value(2, false)
		body.set_collision_mask_value(3, false)
		if body.near_dung:
			body.crossing = true
	else:
		#body.z_index = 3
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(3, true)
