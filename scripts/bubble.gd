extends Node2D


@export_subgroup("Nodes")
@export var reference: Node
@export var image: Sprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_timer: Timer = $DeadTimer


func _ready() -> void:
	visible = false
	image.visible = false
	image.position = position


func pop():
	visible = true
	animated_sprite_2d.play("pop")


func _on_sprite_2d_animation_finished() -> void:
	image.visible = true
	dead_timer.start()


func _on_dead_timeout() -> void:
	image.queue_free()
	queue_free()
