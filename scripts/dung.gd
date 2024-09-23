extends Node2D


@export_subgroup("")
@export var dung_ball: RigidBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == dung_ball:
		dung_ball.dung_size(clamp(dung_ball.dung_n + 1, 0, 10))
		queue_free()
