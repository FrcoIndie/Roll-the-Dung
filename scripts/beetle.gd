extends CharacterBody2D


# --- Variables ---
@onready var state_chart: StateChart = $StateChart
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_polygon_2d_bend: CollisionPolygon2D = $CollisionPolygon2DBend
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight
@onready var ray_cast_2d_dung: RayCast2D = $RayCast2DDung
@onready var ray_cast_2d_floor: RayCast2D = $RayCast2DFloor
@onready var timer: Timer = $Timer

@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var forces_component: ForcesComponent
@export var deform_component: DeformComponent

@export_subgroup("Dung")
@export var dung_ball: RigidBody2D

const BASE_PUSH_FORCE: float = 10.0

var direction: float = 0.0
var over_dung: bool = false
var near_dung: int = 0
var push_force: float = BASE_PUSH_FORCE
var throwed: bool = true


# --- Functions ---
# Process
func _physics_process(delta: float) -> void:
	# Components
	direction = input_component.direction
	gravity_component.handle_gravity(self, delta)
	forces_component.beetle_forces(self, push_force)
	
	dung_detection()
	
	state_chart.set_expression_property("throwed", throwed)
	# BeetleMovement States' Transitions
	if is_on_floor():
		if Input.is_action_just_released("bend"):
			state_chart.send_event("bend_to_throw")
		if Input.is_action_pressed("bend"):
			state_chart.send_event("start_bending")
		else:
			if direction == 0.0 and near_dung == 0:
				state_chart.send_event("to_rest")
			elif direction != 0:
				state_chart.send_event("start_walking")
				if sign(near_dung) == sign(direction):
					state_chart.send_event("start_pushing")
	else:
		state_chart.send_event("start_falling")
	
	move_and_slide()


# Dung Detection
func dung_detection():
	if ray_cast_2d_left.is_colliding():
		state_chart.send_event("approaching_dung")
		near_dung = -1
	elif ray_cast_2d_right.is_colliding():
		state_chart.send_event("approaching_dung")
		near_dung = 1
	elif ray_cast_2d_dung.is_colliding():
		state_chart.send_event("standing_on_dung")
	else:
		state_chart.send_event("moving_away_from_dung")
		near_dung = 0


# --- FSM ---
# 1. BeetleMovement States
# 1.1. Idle State
func _on_idle_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	animation_component.animate(self, "idle", direction)


# 1.2. Walk State
func _on_walk_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "accel", direction, delta)
	animation_component.animate(self, "walk", direction)


# 1.3. Hold State
func _on_dung_idle_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	animation_component.animate(self, "hold", near_dung)


# 1.4. Dung State
func _on_dung_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "accel", direction, delta)
	animation_component.animate(self, "dung", direction)
	push_force = BASE_PUSH_FORCE
	if direction != near_dung:
		state_chart.send_event("stop_pushing")


# 1.5. Bend State
func _on_bend_state_entered() -> void:
	throwed = false
	animation_component.animate(self, "bend", direction)
	set_collision_mask_value(3, false)
	deform_component.change_collision_shape(collision_polygon_2d_bend)

func _on_bend_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)

func _on_bend_state_exited() -> void:
	set_collision_mask_value(3, true)
	deform_component.change_collision_shape(collision_shape_2d)


# 1.6. Throw State
func _on_throw_state_entered() -> void:
	animation_component.animate(self, "throw", direction)
	timer.start()

func _on_throw_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	push_force = 150.0

func _on_throw_state_exited() -> void:
	push_force = BASE_PUSH_FORCE

func _on_timer_timeout() -> void:
	throwed = true

# 1.7. Climb State
#func _on_climb_state_entered() -> void:
	#animation_component.animate(self, "climb", direction)

#func _on_climb_state_physics_processing(delta: float) -> void:
	#set_collision_layer_value(2, false)
	##set_collision_mask_value(3, false)
	##forces_component.beetle_forces(self, 0.0)
	#var dung_n = dung_ball.dung_n
	#var x = near_dung * (1 + dung_ball.collision_shape_2d.shape.radius) * 5
	#var y = (dung_ball.collision_shape_2d.shape.radius - 2) * 5
	#match animated_sprite_2d.frame:
		#0:
			#position.x = dung_ball.position.x - x
		#1:
			#position.x = dung_ball.position.x - x
			#position.y = dung_ball.position.y
		#2:
			#position.x = dung_ball.position.x - x
			#position.y = dung_ball.position.y


# 1.7. Fall State
func _on_fall_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "fall", direction, delta)
	animation_component.animate(self, "fall", direction)


# 2. RelativeToDung States
# 2.1. Far State


# 2.2. Beside State


# 2.3. Over State
