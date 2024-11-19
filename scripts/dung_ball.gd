extends RigidBody2D


signal grow_dung_ball

@onready var sprite: Sprite2D = $Sprite
@onready var hit_box: CollisionShape2D = $HitBox
@onready var ground_box = $Area/GroundBox
@export var dung_n: int = 0

const MAX_ANG_VEL = 0.5

var on_ground: bool = false
var on_water: bool = false


# --- Functions ---
func _ready() -> void:
	dung_size(dung_n)


func _physics_process(delta: float) -> void:
	if on_water:
		if abs(angular_velocity) > MAX_ANG_VEL:
			angular_velocity = sign(angular_velocity) * MAX_ANG_VEL


# To manage the size and weight of the dung ball
func dung_size(n: int):
	mass = 0.01 * n + 0.01
	sprite.frame = n
	hit_box.shape.radius = 5 + n
	ground_box.shape.radius = 6 + n
	dung_n += 1


# Ground Detection
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		on_ground = true

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		on_ground = false
