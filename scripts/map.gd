extends Node2D

@onready var victoria = $Victoria
@onready var space_theme = $SpaceTheme
@onready var rigid_beetle = $RigidBeetle
@onready var oa_2_elephant = $"Path2D/PathFollow2D/OA2 Elephant"
@onready var path_follow_2d = $Path2D/PathFollow2D

var flipped: bool = false


func _ready():
	space_theme.play()
	space_theme.volume_db = -80.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress = path_follow_2d.progress_ratio
	
	if progress > 0.5 and !flipped:
		oa_2_elephant.animated_sprite_2d.flip_h = false
		flipped = true
		
	elif progress < 0.1 and flipped:
		oa_2_elephant.animated_sprite_2d.flip_h = true
		flipped = false


func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	victoria.visible = true

func _on_space_theme_finished():
	space_theme.play()


func on_space_entered(body):
	if body == rigid_beetle:
		var tween = create_tween()
		tween.tween_property(space_theme, "volume_db", 0, 0.7)


func on_space_exited(body):
	if body == rigid_beetle:
		var tween = create_tween()
		tween.tween_property(space_theme, "volume_db", -80.0, 1.0)
