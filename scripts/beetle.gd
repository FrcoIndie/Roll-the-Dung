extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@export var dung_body: RigidBody2D

const SPEED: float = 450.0
const BASE_PUSH_FORCE: float = 10.0

var near_dung: bool = false # When the beetle enters in the Area2D margin of the dung
var crossing: bool = false # Flag to prevent normal movement when the beetle is crossing the ball
var push_force: float = BASE_PUSH_FORCE
var forces_active: bool = true
var flag_down: bool = true # Flag to avoid the "down" animation from looping


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_down", "")
	beetle_movement(direction, delta)
	move_and_slide()
	beetle_forces(forces_active)


# Movement and animation handler of the beetle
func beetle_movement(direction, delta):
	if is_on_floor():
		if Input.is_action_pressed("action") && near_dung:
			ignore_dung(true)
			crossing = true
			if direction == Vector2(1, 0):
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("walk")
				velocity.x = direction.x * SPEED
			elif direction == Vector2(-1, 0):
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.play("walk")
				velocity.x = direction.x * SPEED
		else:
			if !crossing:
				ignore_dung(false)
				if Input.is_action_just_released("move_down"):
					push_force = 2000.0
				if direction.y < 0:
					push_force = BASE_PUSH_FORCE
					velocity.x = move_toward(velocity.x, 0, SPEED)
					if flag_down:
						animated_sprite_2d.play("down")
						flag_down = false
					collision_down(true)
				else:
					flag_down = true
					collision_down(false)
					if direction == Vector2(1, 0):
						animated_sprite_2d.flip_h = false
						if near_dung:
							animated_sprite_2d.play("dung")
						else:
							animated_sprite_2d.play("walk")
						velocity.x = direction.x * SPEED
						push_force = BASE_PUSH_FORCE
					elif direction == Vector2(-1, 0):
						animated_sprite_2d.flip_h = true
						if near_dung:
							animated_sprite_2d.play("dung")
						else:
							animated_sprite_2d.play("walk")
						velocity.x = direction.x * SPEED
						push_force = BASE_PUSH_FORCE
					else:
						animated_sprite_2d.play("idle")
						velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		animated_sprite_2d.play("fall")
		velocity += get_gravity() * delta


# Forces applied to the dung ball
func beetle_forces(active):
	if active:
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * push_force)


# Conveniences when we press "action"
func ignore_dung(active):
	if active:
		z_index = 1
		set_collision_mask_value(3, false)
		dung_body.set_collision_mask_value(2, false)
	else:
		z_index = 3
		set_collision_mask_value(3, true)
		dung_body.set_collision_mask_value(2, true)


# Conveniences when we press "move_down"
func collision_down(active):
	if active:
		collision_shape_2d.disabled = true
		collision_polygon_2d.disabled = false
		set_collision_mask_value(3, false)
		#beetle_forces(false)
	else:
		collision_shape_2d.disabled = false
		collision_polygon_2d.disabled = true
		set_collision_mask_value(3, true)
		#beetle_forces(true)
