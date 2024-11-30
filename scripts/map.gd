extends Node2D

@onready var victoria = $Victoria
@onready var space_theme = $SpaceTheme

# Called when the node enters the scene tree for the first time.
func _ready():
	space_theme.play()
	space_theme.volume_db = -80.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	victoria.visible = true


func _on_space_area_body_entered(body):
	var tween = create_tween()
	tween.tween_property(space_theme, "volume_db", 0, 0.7)


func _on_space_area_body_exited(body):
	var tween = create_tween()
	tween.tween_property(space_theme, "volume_db", -80.0, 1.0)


func _on_space_theme_finished():
	space_theme.play()
