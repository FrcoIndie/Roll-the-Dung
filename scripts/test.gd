extends Node2D

@onready var label_4: Label = $Label4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.content_scale_mode
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_victory_area_body_entered(body: Node2D) -> void:
	label_4.visible = true

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	#$Doors/Door_R/Spawn
