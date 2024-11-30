class_name AnimationComponent
extends Node2D


@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D


func horizontal_flip(direction: float) -> void:
	if direction == 0:
		return
	
	if direction > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func animate(body: CharacterBody2D, animation : String, direction: float) -> void:
	horizontal_flip(direction)
	sprite.play(animation)
