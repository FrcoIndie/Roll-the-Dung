extends Node2D


@onready var label_4: Label = $Label4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.content_scale_mode


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _on_victory_area_body_entered(body: Node2D) -> void:
	print("a")
	label_4.visible = true
