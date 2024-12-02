extends Node2D

@onready var victoria = $Victoria
@onready var space_theme = $SpaceTheme
@onready var rigid_beetle: RigidBody2D = $RigidBeetle
@onready var dung_ball: RigidBody2D = $"Dung Ball"
@onready var oa_2_elephant = $"Path2D/PathFollow2D/OA2 Elephant"
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var bubble: Node2D = $Bubble
@onready var bubble_1: Node2D = $Bubble1
@onready var timer_end: Timer = $TimerEnd
@onready var bubble_2: Node2D = $Bubble2
@onready var timer_end_2: Timer = $TimerEnd2

var flipped: bool = false
var volver: bool = false


func _ready():
	space_theme.play()
	space_theme.volume_db = -80.0
	bubble.pop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress = path_follow_2d.progress_ratio
	
	if progress > 0.5 and !flipped:
		oa_2_elephant.animated_sprite_2d.flip_h = false
		flipped = true
		
	elif progress < 0.1 and flipped:
		oa_2_elephant.animated_sprite_2d.flip_h = true
		flipped = false
	
	if volver && Input.is_action_just_pressed("move_right"):
		get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")

func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("Dung Ball"):
		dung_ball.visible = false
		dung_ball.angular_velocity = 0.0
		dung_ball.linear_velocity = Vector2.ZERO
		rigid_beetle.visible = false
		rigid_beetle.mass = 1000
		timer_end.start()
		bubble_1.animated_sprite_2d.flip_h = true
		bubble_1.pop()

func _on_timer_end_timeout() -> void:
	bubble_2.pop()
	timer_end_2.start()

func _on_timer_end_2_timeout() -> void:
	victoria.visible = true
	volver = true


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


func _on_area_water_body_entered(body: Node2D) -> void:
	if body.is_in_group("Beetle"):
		get_tree().reload_current_scene()
