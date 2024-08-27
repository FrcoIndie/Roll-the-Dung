class_name AnimationComponent
extends Node2D


@export_subgroup("Nodes")
@export var 	sprite: AnimatedSprite2D


func horizontal_flip(direction: Vector2) -> void:
	if direction.x == 0:
		return
	
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func animate(body: CharacterBody2D, animation : String, direction: Vector2) -> void:
	horizontal_flip(direction)
	sprite.play(animation)
