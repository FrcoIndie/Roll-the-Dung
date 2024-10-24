extends RigidBody2D


signal grow_dung_ball

@onready var sprite: Sprite2D = $Sprite
@onready var hit_box: CollisionShape2D = $HitBox

@export var dung_n: int = 0

var on_ground: bool = false


# --- Functions ---
func _ready() -> void:
	dung_size(dung_n)


func _process(delta: float) -> void:
	pass


# To manage the size and weight of the dung ball
func dung_size(n: int):
	mass += n/2
	sprite.frame = n
	hit_box.shape.radius = 5 + n
	dung_n += 1


# Ground Detection
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		on_ground = true

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		on_ground = false
