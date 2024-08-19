extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("moveL", "moveR")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")

	move_and_slide()
