extends Node2D


@onready var bubble: Node2D = $Bubble


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	bubble.pop()
