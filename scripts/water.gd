extends Area2D


@onready var collision_water: CollisionShape2D = $CollisionWater

@export_subgroup("Dung")
@export var dung_ball: RigidBody2D
@export var BASE_PUSH_VECTOR: Vector2 = Vector2(0.0, 0.1)

var water_top: float
var ball_c: Vector2
var ball_r: float


func _ready() -> void:
	water_top = collision_water.position.y - collision_water.shape.size.y/2


func _process(delta: float) -> void:
	var prop = proportions(dung_ball)
	if dung_ball.on_water:
		dung_ball.linear_velocity -= thrust_force(2 * ball_r, prop)


func thrust_force(vol: float, prop: float) -> Vector2:
	var thrust_force = vol * prop * BASE_PUSH_VECTOR
	return thrust_force


func proportions(body: RigidBody2D) -> float:
	ball_c = dung_ball.position
	ball_r = dung_ball.hit_box.shape.radius
	var a = ball_c.y - water_top
	var b = ball_r - a
	if b < 0:
		return 2 * ball_r
	else:
		var prop = b / (2 * ball_r)
		return prop


func _on_body_entered(body: Node2D) -> void:
	if body == dung_ball:
		dung_ball.on_water = true

func _on_body_exited(body: Node2D) -> void:
	if body == dung_ball:
		dung_ball.on_water = false
