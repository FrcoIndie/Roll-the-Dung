extends CharacterBody2D


@onready var state_chart: StateChart = $StateChart
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_roll: CollisionShape2D = $CollisionShape2DRoll
@onready var collision_polygon_2d_bend: CollisionPolygon2D = $CollisionPolygon2DBend
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight

@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var forces_component: ForcesComponent
@export var deform_component: DeformComponent

var direction: Vector2 = Vector2.ZERO
var near_dung: float = 0.0


func _physics_process(delta: float) -> void:
	direction = input_component.direction
	
	# Components
	gravity_component.handle_gravity(self, delta)
	forces_component.beetle_forces(self)
	
	dung_detection()
	# State Charts' Transitions
	if is_on_floor():
		if direction == Vector2.ZERO:
			state_chart.send_event("idling")
		elif abs(direction.x) != 0.0 and direction.y == 0.0:
			state_chart.send_event("walking")
			if sign(near_dung) == sign(direction.x):
				state_chart.send_event("dunging")
		elif direction.y > 0.0:
			state_chart.send_event("rolling")
		elif direction.y < 0.0:
			state_chart.send_event("bending")
	else:
		if direction.y > 0.0:
			state_chart.send_event("rolling")
		else:
			state_chart.send_event("falling")
	
	move_and_slide()


func dung_detection():
	if ray_cast_2d_left.is_colliding():
		near_dung = -1
	elif ray_cast_2d_right.is_colliding():
		near_dung = 1
	else:
		near_dung = 0


# Idle State
func _on_idle_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	animation_component.animate(self, "idle", direction)
	deform_component.change_collision_shape(collision_shape_2d)


# Walk State
func _on_walk_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "accel", direction, delta)
	animation_component.animate(self, "walk", direction)
	deform_component.change_collision_shape(collision_shape_2d)


# Dung State
func _on_dung_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "accel", direction, delta)
	animation_component.animate(self, "dung", direction)
	deform_component.change_collision_shape(collision_shape_2d)


# Roll State
func _on_roll_state_entered() -> void:
	animation_component.animate(self, "roll", direction)
	deform_component.change_collision_shape(collision_shape_2d_roll)

func _on_roll_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "roll", direction, delta)


# Bend State
func _on_bend_state_entered() -> void:
	animation_component.animate(self, "bend", direction)
	deform_component.change_collision_shape(collision_polygon_2d_bend)

func _on_bend_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)


# Fall State
func _on_fall_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "fall", direction, delta)
	animation_component.animate(self, "fall", direction)
	deform_component.change_collision_shape(collision_shape_2d)
