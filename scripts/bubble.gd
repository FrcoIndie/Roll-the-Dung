extends Node2D


@export_subgroup("Content")
@export var image: Sprite2D


func pop_content():
	visible = true
	image.visible = true
