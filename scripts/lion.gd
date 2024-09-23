extends StaticBody2D

@export_subgroup("Nodes")
@export var shapes: Array[CollisionPolygon2D] = []

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_frame_0: CollisionPolygon2D = $CollisionFrame0


func _physics_process(delta: float) -> void:
	if !animated_sprite_2d.is_playing():
		collision_frame_0.disabled = false
	#match animated_sprite_2d.frame:
		#0:
			#change_collision_shape(shapes[0])
		#2:
			#change_collision_shape(shapes[1])
		#3:
			#change_collision_shape(shapes[2])
		#4:
			#change_collision_shape(shapes[3])
		#5:
			#change_collision_shape(shapes[2])
		#6:
			#change_collision_shape(shapes[1])
		#7:
			#change_collision_shape(shapes[0])
#
#
#func change_collision_shape(shape: CollisionPolygon2D) -> void:
	#shape.disabled = false
	#for i in shapes:
		#if i != shape:
			#i.disabled = true
	


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("default")
	collision_frame_0.disabled = true
