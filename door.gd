extends Area2D

#class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@export var beetle: CharacterBody2D

@onready var spawn = $Spawn

func _on_body_entered(body: Node2D) -> void:
	#print(body)
	#if body == beetle:
		#print("El body es Beetle")
	NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
