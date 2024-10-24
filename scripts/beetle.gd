extends CharacterBody2D


# --- Variables ---
@onready var state_chart: StateChart = $StateChart
@onready var animator: AnimatedSprite2D = $Animator
@onready var hit_box: CollisionShape2D = $HitBox
@onready var dung_ray_cast: RayCast2D = $"Dung RayCast"
@onready var timer: Timer = $Timer

@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var forces_component: ForcesComponent

@export_subgroup("Dung")
@export var dung_ball: RigidBody2D
@export var BASE_PUSH_FORCE: float = 10.0

var direction: float = 0.0 # To track the input of the player
var over_dung: bool = false # 
var near_dung: bool = false # True if the dung ball is inside the dunbox
var dung_position: int # To keep track if the dung is at the left or at the right of the beetle
var push_force: float = BASE_PUSH_FORCE


# --- Functions ---
func _physics_process(delta: float) -> void:
	# Components
	direction = input_component.direction
	gravity_component.handle_gravity(self, delta)
	forces_component.beetle_forces(self, push_force)
	# Movement
	dung_detection()
	velocity.x = clamp(velocity.x, -movement_component.max_speed, movement_component.max_speed)
	move_and_slide()


# Dung Detection
func dung_detection():
	# Horizontal
	if dung_ball.position.x < position.x:
		dung_position = -1
	else:
		dung_position = 1
	# Vertical
	if dung_ray_cast.is_colliding():
		over_dung = true
	else:
		over_dung = false

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Dung Balls"):
		near_dung = true

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Dung Balls"):
		near_dung = false


# --- FSM ---
# 1 BeetleMovement States
# 1.1 Idle State
func _on_idle_state_entered() -> void:
	pass

func _on_idle_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	animation_component.animate(self, "idle", direction)
	if is_on_floor():
		if direction == 0 && near_dung && !over_dung:
			state_chart.send_event("to_hold")
		elif direction != 0:
			state_chart.send_event("to_walk")
	else:
		state_chart.send_event("to_fall")

func _on_idle_state_exited() -> void:
	pass


# 1.2 Walk State
func _on_walk_state_entered() -> void:
	pass

func _on_walk_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "accel", direction, delta)
	animation_component.animate(self, "walk", direction)
	if is_on_floor():
		if direction == 0 && !near_dung:
			state_chart.send_event("to_idle")
		elif direction == dung_position && near_dung && !over_dung:
			state_chart.send_event("to_hold")
	else:
		state_chart.send_event("to_fall")

func _on_walk_state_exited() -> void:
	pass


# 1.3 Hold State
func _on_hold_state_entered() -> void:
	animation_component.animate(self, "hold", dung_position)

func _on_dung_idle_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	if is_on_floor():
		if direction == 0 && !near_dung:
			state_chart.send_event("to_idle")
		elif direction == dung_position && near_dung && !over_dung:
			state_chart.send_event("to_push")
		elif (direction == -dung_position) || (direction != 0 && !near_dung):
			state_chart.send_event("to_walk")
		elif Input.is_action_pressed("climb") && near_dung && !over_dung:
			state_chart.send_event("to_climb")
	else:
		state_chart.send_event("to_fall")

func _on_hold_state_exited() -> void:
	pass


# 1.4 Push State
func _on_dung_state_entered() -> void:
	push_force = BASE_PUSH_FORCE

func _on_dung_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "accel", direction, delta)
	animation_component.animate(self, "dung", direction)
	if is_on_floor():
		if direction == 0 && !near_dung:
			state_chart.send_event("to_idle")
		elif direction == 0 && near_dung && !over_dung:
			state_chart.send_event("to_hold")
		elif (direction != dung_position) || (direction != 0 && !near_dung):
			state_chart.send_event("to_walk")
		elif Input.is_action_pressed("climb") && near_dung && !over_dung:
			state_chart.send_event("to_climb")
	else:
		state_chart.send_event("to_fall")

func _on_dung_state_exited() -> void:
	pass


# 1.5 Climb State
func _on_climb_state_entered() -> void:
	animation_component.animate(self, "climb", direction)
	gravity_component.gravity = 0.0
	hit_box.disabled = true
	#var tween := get_tree().create_tween()
	#tween.tween_property(self, "position", Vector2(dung_ball.position.x - x - dung_position*c, dung_ball.position.y), 0.125*sqrt(dung_ball.dung_n))
	#tween.tween_property(self, "position", Vector2(dung_ball.position.x, dung_ball.position.y - y - c), 0.25*sqrt(dung_ball.dung_n))

func _on_climb_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "decel", direction, delta)
	# Climbing animation offsets
	var c = hit_box.shape.radius * scale.x
	var x = dung_position * (dung_ball.hit_box.shape.radius) * scale.x
	var y = (dung_ball.hit_box.shape.radius) * scale.x
	match animator.frame:
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
	if !animator.is_playing():
		state_chart.send_event("to_idle")

func _on_climb_state_exited() -> void:
	gravity_component.gravity = 600.0
	hit_box.disabled = false


# 1.6 Fall State
func _on_fall_state_entered() -> void:
	pass

func _on_fall_state_physics_processing(delta: float) -> void:
	movement_component.beetle_movement(self, "fall", direction, delta)
	animation_component.animate(self, "fall", direction)
	if is_on_floor():
		state_chart.send_event("to_idle")

func _on_fall_state_exited() -> void:
	pass
