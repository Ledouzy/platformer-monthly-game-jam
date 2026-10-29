extends CharacterBody2D


# Player - by Léon
# Player Movement and logic

@export var SPEED = 300.0 # velocity applied each frame moving
@export var MAX_SPEED = 200 # max speed the character can move (relative x-coords)
@export var MAX_JUMP_SPEED = 300 # max speed the character can jump (relative y-coords)
@export var ROTATION_SPEED = 5 # speed at which rotation occurs
@export var JUMP_VELOCITY = -150.0 # velocity applied at jump
@export var hover_slowdown = 400000 # speed at which we stop the player after a jump
@export var hover_slowdown_multiplier = 0.25 # multiplier to gravity when holding jump after hover
@export var gravity_multiplier = 0.5 # multiplier to gravity

var hover: bool = false
var cant_hover: bool = false

@onready var hover_timer: Timer = $HoverTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !hover:
		var slowdown_multiplier = 1
		if Input.is_action_pressed("jump"):
			slowdown_multiplier = hover_slowdown_multiplier
		velocity += get_gravity() * gravity_multiplier * slowdown_multiplier * delta
	if is_on_floor():
		cant_hover = false
		
	# Release jump key
	if Input.is_action_just_released("jump"):
		# Tap Jump
		if velocity.length() < 0:
			velocity = Vector2(-velocity.x * sin(rotation), velocity.y * cos(rotation)) * 0.25
		# Cancel Hover
		hover = false
		hover_timer.stop()
	
	# Hover in air
	if Input.is_action_just_pressed("jump") and !cant_hover:
		# starts hovering
		hover = true
		hover_timer.start()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# starts hovering
		hover = true
		hover_timer.start()
		
		velocity += Vector2(-JUMP_VELOCITY * sin(rotation), JUMP_VELOCITY * cos(rotation))
		# Cap speed don't really need this anymore
		if sqrt(pow((velocity.x * sin(rotation)),2) + pow((velocity.y * cos(rotation)),2)) > MAX_JUMP_SPEED:
			velocity = velocity.normalized() * MAX_JUMP_SPEED
		
		# Stop after a while to not accelerate infinitely. Might lead to some problem because we simply go toward 0 and not go to 0
		await get_tree().create_timer(0.3).timeout
		var hovx = move_toward(velocity.x, 0, abs(hover_slowdown * sin(rotation)) * delta)
		var hovy = move_toward(velocity.y, 0, abs(hover_slowdown * cos(rotation)) * delta)
		cant_hover = true

		velocity = Vector2(hovx, hovy)
	
	var rotate_direction := Input.get_axis("turn_left", "turn_right")
	# Rotate in direction
	if rotate_direction:
		rotation = rotation + ROTATION_SPEED * rotate_direction * delta
		print("new rot: ", rotation)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		if abs(velocity.x) < MAX_SPEED:
			print("rot: ", rotation)
			print("velocity: ", Vector2(SPEED * cos(rotation), SPEED * sin(rotation)))
			velocity += direction * Vector2(SPEED * cos(rotation), SPEED * sin(rotation)) * delta
		# if x value according to current rotation is greater than max speed
		if sqrt(pow((velocity.x * cos(rotation)),2) + pow((velocity.y * sin(rotation)),2)) > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		# Calculate the friction/slowdown to not accelerate infinitely
		var frix = move_toward(velocity.x, 0, abs(SPEED) * delta)
		var friy = move_toward(velocity.y, 0, abs(SPEED * sin(rotation)) * delta)
		velocity = Vector2(frix, friy)

	move_and_slide()


func _on_hover_timer_timeout() -> void:
	hover = false
