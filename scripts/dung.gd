extends RigidBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

@export var beetle_body: CharacterBody2D


func _ready() -> void:
	contact_monitor = true
	set_max_contacts_reported(3)


func _process(delta: float) -> void:
	pass


# To manage the size and weight of the dung ball
func dung_size(n):
	animated_sprite_2d.frame = n
	collision_shape_2d.radius = 6 + n
	area_2d.radius = 7 + n


# When the beetle enters the outside margin of the ball
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body == beetle_body:
		beetle_body.near_dung = true
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body == beetle_body:
		beetle_body.near_dung = false
		beetle_body.crossing = false
