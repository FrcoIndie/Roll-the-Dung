class_name InputComponent
extends Node2D


var direction: Vector2 = Vector2(0, 0)


func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "bend", "roll")
