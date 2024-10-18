extends Node

const scene0 = preload("res://scenes/test.tscn")
const scene1 = preload("res://scenes/test2.tscn")

var spawn_door_tag

signal on_trigger_player_spawn

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"prev": 
			scene_to_load = scene0
		"next":
			scene_to_load = scene1
			
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
		
func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
