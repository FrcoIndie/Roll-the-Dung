extends RigidBody2D


# --- Variables ---
@onready var state_chart: StateChart = $StateChart
@onready var animator: AnimatedSprite2D = $Animator
@onready var hit_box: CollisionShape2D = $HitBox
@onready var dung_ray_cast: RayCast2D = $"DungRayCast"

@export_subgroup("Components")
@export var input_component: InputComponent
@export var rigid_movement_component: RigidMovementComponent
@export var rigid_animation_component: RigidAnimationComponent

@export_subgroup("Dung")
@export var dung_ball: RigidBody2D

const PUSH_FORCE: float = 0.25

var direction: float = 0.0 # To track the input of the player
var over_dung: bool = false # 
var near_dung: bool = false # True if the dung ball is inside the dunbox
var on_floor: bool = false # Replacement for is_on_floor of CharacterBody2D
var dung_position: int # To keep track if the dung is at the left or at the right of the beetle
var push_force: float = PUSH_FORCE


# --- Functions ---
func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(3)
	set_can_sleep(false)
	set_lock_rotation_enabled(true)


func _process(delta: float) -> void:
	direction = input_component.direction
	rigid_movement_component.beetle_movement(self, direction, delta)
	dung_detection()


func dung_detection():
	# Dung
	if dung_ball.position.x < position.x:
		dung_position = -1
	else:
		dung_position = 1
	if dung_ray_cast.is_colliding():
		over_dung = true
	else:
		over_dung = false


# Dung Detection
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Dung Ball"):
		near_dung = true

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Dung Ball"):
		near_dung = false


# Floor Detection
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Ground"):
		on_floor = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Ground"):
		on_floor = false


# --- FSM ---
# Idle State
func _on_idle_state_entered() -> void:
	pass

func _on_idle_state_physics_processing(delta: float) -> void:
	rigid_animation_component.animate("idle", direction)
	if on_floor || over_dung:
		if direction == 0 && near_dung && !over_dung:
			state_chart.send_event("to_hold")
		elif direction != 0:
			state_chart.send_event("to_walk")
	else:
		state_chart.send_event("to_fall")

func _on_idle_state_exited() -> void:
	pass


# Walk State
func _on_walk_state_entered() -> void:
	pass

func _on_walk_state_physics_processing(delta: float) -> void:
	rigid_animation_component.animate("walk", direction)
	if on_floor || over_dung:
		if direction == 0 && !near_dung:
			state_chart.send_event("to_idle")
		elif direction == dung_position && near_dung && !over_dung:
			state_chart.send_event("to_hold")
	else:
		state_chart.send_event("to_fall")

func _on_walk_state_exited() -> void:
	pass


# Hold State
func _on_hold_state_entered() -> void:
	rigid_animation_component.animate("hold", dung_position)

func _on_hold_state_physics_processing(delta: float) -> void:
	if on_floor || over_dung:
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


# Push State
func _on_push_state_entered() -> void:
	pass

func _on_push_state_physics_processing(delta: float) -> void:
	rigid_animation_component.animate("push", dung_position)
	if on_floor || over_dung:
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

func _on_push_state_exited() -> void:
	pass


# Climb State
func _on_climb_state_entered() -> void:
	rigid_animation_component.animate("climb", dung_position)
	set_freeze_enabled(true)
	hit_box.set_disabled(true)

func _on_climb_state_physics_processing(delta: float) -> void:
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
	set_freeze_enabled(false)
	hit_box.set_disabled(false)


# Fall State
func _on_fall_state_entered() -> void:
	pass

func _on_fall_state_physics_processing(delta: float) -> void:
	rigid_animation_component.animate("fall", direction)
	if on_floor || over_dung:
		state_chart.send_event("to_idle")

func _on_fall_state_exited() -> void:
	pass
