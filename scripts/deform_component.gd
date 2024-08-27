class_name DeformComponent
extends Node2D

@export_subgroup("Nodes")
@export var shapes: Array[Node2D] = []

func change_collision_shape(shape: Node2D) -> void:
	shape.disabled = false
	for i in shapes:
		if i != shape:
			i.disabled = true
