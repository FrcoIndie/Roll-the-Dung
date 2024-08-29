class_name InputComponent
extends Node2D


var direction: float = 0.0


func _process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
