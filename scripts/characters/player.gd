extends CharacterBody2D


@export var SPEED = 300.0
@export var MAX_SPEED = 200
@export var JUMP_VELOCITY = -200.0
@export var hover_slowdown = 400


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !Input.is_action_pressed("jump"):
		velocity += get_gravity() * 0.5 * delta
	
	if Input.is_action_pressed("jump"):
		velocity.y = move_toward(velocity.y, 0, hover_slowdown * delta)

	# Tap jump.
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = velocity.y * 0.5
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if abs(velocity.x) < MAX_SPEED:
			velocity.x += direction * SPEED * delta
		if abs(velocity.x) > MAX_SPEED:
			velocity.x = MAX_SPEED * sign(velocity.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
