extends RigidBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var dung_n: int = 0


func _ready() -> void:
	dung_size(dung_n)


func _process(delta: float) -> void:
	pass


# To manage the size and weight of the dung ball
func dung_size(n: int):
	sprite_2d.frame = n
	collision_shape_2d.shape.radius = 6 + n
