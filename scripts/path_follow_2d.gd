extends PathFollow2D


@export var path_vel: float = 0.01


func _process(delta: float) -> void:
	progress_ratio += delta * path_vel
