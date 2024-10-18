extends CharacterBody2D

class_name Beetle

# --- Variables ---
@onready var state_chart: StateChart = $StateChart
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_polygon_2d_bend: CollisionPolygon2D = $CollisionPolygon2DBend
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight
@onready var ray_cast_2d_dung: RayCast2D = $RayCast2DDung
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
@export var BASE_PUSH_FORCE: float = 10.0

var direction: float = 0.0
var over_dung: bool = false
var near_dung: int = 0 # The beetle is standing besides the dung when != 0, -1: (D)B | 1: B(D)
var dung_position: int = near_dung # To keep track if the dung is at the left or at the right of the beetle
var push_force: float = BASE_PUSH_FORCE
var throwed: bool = true
var frame_counter: int = 0
var climbed: bool = false
var inter: bool = false

# --- Functions ---

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)

# Process
func _physics_process(delta: float) -> void:
	# Components
	if climbed and !ray_cast_2d_dung.is_colliding():
		inter = true
		climbed = false
	if inter:
		if frame_counter <= 30:
			dung_ball.FREEZE_MODE_KINEMATIC == 1
			frame_counter += 1
		else:
			dung_ball.FREEZE_MODE_KINEMATIC == 0
			frame_counter = 0
			inter = false

	direction = input_component.direction
	gravity_component.handle_gravity(self, delta)
	
	dung_detection()
	
	velocity.x = clamp(velocity.x, -movement_component.max_speed, movement_component.max_speed)
	
	state_chart.set_expression_property("throwed", throwed)
	state_chart.set_expression_property("over_dung", over_dung)

	# BeetleMovement States' Transitions
	if is_on_floor():
		forces_component.beetle_forces(self, push_force)
		if Input.is_action_just_released("bend"):
			state_chart.send_event("bend_to_throw")
		if Input.is_action_pressed("bend"):
			state_chart.send_event("start_bending")
		else:
			if direction == 0.0 and near_dung == 0:
				state_chart.send_event("to_rest")
			elif near_dung != 0 and Input.is_action_pressed("climb"):
				state_chart.send_event("start_climbing")
				climbed = true
			elif direction != 0:
				state_chart.send_event("start_walking")
				if sign(near_dung) == sign(direction):
					state_chart.send_event("start_pushing")
	else:
		state_chart.send_event("start_falling")
	
	move_and_slide()

# Dung Detection
func dung_detection():
	ray_cast_2d_left.target_position.x = -5 - sqrt(dung_ball.dung_n)
	ray_cast_2d_right.target_position.x = 5 + sqrt(dung_ball.dung_n)
	
	if dung_ball.position.x < position.x:
		dung_position = -1
	else:
		dung_position = 1
	
	# Vertical positioning
	if ray_cast_2d_dung.is_colliding():
		state_chart.send_event("stepping_dung")
		over_dung = true
	elif ray_cast_2d_left.is_colliding():
		state_chart.send_event("approaching_dung")
		near_dung = -1
	elif ray_cast_2d_right.is_colliding():
		state_chart.send_event("approaching_dung")
		near_dung = 1
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
func _on_climb_state_entered() -> void:
	animation_component.animate(self, "climb", direction)
	#var tween := get_tree().create_tween()
	#tween.tween_property(self, "position", Vector2(dung_ball.position.x - x - dung_position*c, dung_ball.position.y), 0.125*sqrt(dung_ball.dung_n))
	#tween.tween_property(self, "position", Vector2(dung_ball.position.x, dung_ball.position.y - y - c), 0.25*sqrt(dung_ball.dung_n))

func _on_climb_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	collision_shape_2d.disabled = true
	gravity_component.gravity = 0.0
	
	var c = collision_shape_2d.shape.height/2 * scale.x
	var x = dung_position * (dung_ball.collision_shape_2d.shape.radius) * scale.x
	var y = (dung_ball.collision_shape_2d.shape.radius) * scale.x
	match animated_sprite_2d.frame:
		0:
			pass
		1:
			position.x = dung_ball.position.x - x
			position.y = dung_ball.position.y + y/2
		2:
			position.x = dung_ball.position.x - 3*x/4
			position.y = dung_ball.position.y
		3:
			position.x = dung_ball.position.x - 3*x/4 + dung_position * c
			position.y = dung_ball.position.y - y/3
		4:
			position.x = dung_ball.position.x
			position.y = dung_ball.position.y - 2*y/3
		5:
			position.x = dung_ball.position.x
			position.y = dung_ball.position.y - y - c
	
	if !animated_sprite_2d.is_playing():
		collision_shape_2d.disabled = false
		gravity_component.gravity = 600.0

# 1.7. Fall State
func _on_fall_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "fall", direction, delta)
	animation_component.animate(self, "fall", direction)

# 2. RelativeToDung States
# 2.1. Far State


# 2.2. Beside State


# 2.3. Over State
func _on_over_state_physics_processing(delta: float) -> void:
	set_collision_layer_value(2, false)
	push_force = 0.0
	#collision_shape_2d.shape.size.x = 2

func _on_over_state_exited() -> void:
	set_collision_layer_value(2, true)
	push_force = BASE_PUSH_FORCE
	#collision_shape_2d.shape.size.x = 6
	over_dung = false

func _on_spawn(position: Vector2, direction: String):
	global_position = position
	
