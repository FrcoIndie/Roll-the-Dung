extends Area2D

class_name Door

@onready var spawn = $Spawn

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

func _on_body_entered(body):
	NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
