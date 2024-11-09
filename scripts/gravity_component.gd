class_name GravityComponent
extends Node2D


@export_subgroup("Settings")
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var flag_gravity: bool = true
var is_falling: bool = false


func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if !body.is_on_floor() && flag_gravity:
		body.velocity.y += gravity * delta
	
	is_falling = body.velocity.y > 0 && !body.is_on_floor()
