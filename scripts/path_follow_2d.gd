extends PathFollow2D


@export var path_vel: float = 1.0


func _process(delta: float) -> void:
	progress_ratio += delta * path_vel
