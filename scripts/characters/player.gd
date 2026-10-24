extends CharacterBody2D


# Player - by Léon
# Player Movement and logic

@export var SPEED = 300.0
@export var MAX_SPEED = 200
@export var MAX_JUMP_SPEED = 300
@export var ROTATION_SPEED = 5
@export var JUMP_VELOCITY = -150.0
@export var hover_slowdown = 400000

var hover: bool = false
var cant_hover: bool = false

@onready var hover_timer: Timer = $HoverTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !hover:
		velocity += get_gravity() * 0.5 * delta
	if is_on_floor():
		cant_hover = false
		
	# Release jump key
	if Input.is_action_just_released("jump"):
		# Tap Jump
		if velocity.length() < 0:
			velocity = Vector2(-JUMP_VELOCITY * sin(rotation), JUMP_VELOCITY * cos(rotation)) * 0.25
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
		# Cap speed
		if abs(velocity.length()) > MAX_JUMP_SPEED:
			velocity = velocity.normalized() * MAX_JUMP_SPEED
			
		await get_tree().create_timer(0.3).timeout
		var hovx = move_toward(velocity.x, 0, abs(hover_slowdown * sin(rotation)) * delta)
		var hovy = move_toward(velocity.y, 0, abs(hover_slowdown * cos(rotation)) * delta)
		cant_hover = true
		#hovx = velocity.x
		
		#print(cos(rotation),", ", sin(rotation))
		#print(hovx, " ,", hovy)
		
		velocity = Vector2(hovx, hovy)
	
	var rotate_direction := Input.get_axis("turn_left", "turn_right")
	# Rotate Left
	if rotate_direction:
		rotation = rotation + ROTATION_SPEED * rotate_direction * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if abs(velocity.x) < MAX_SPEED:
			velocity += direction * Vector2(SPEED * cos(rotation), SPEED * sin(rotation)) * delta
			#print(direction * Vector2(SPEED * cos(rotation), SPEED * sin(rotation)) * delta)
			#print("velocity: ", velocity)
		if abs(velocity.length()) > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		var frix = move_toward(velocity.x, 0, abs(SPEED) * delta)
		var friy = move_toward(velocity.y, 0, abs(SPEED * sin(rotation)) * delta)
		#print(frix, " ,", friy)
		velocity = Vector2(frix, friy)

	move_and_slide()


func _on_hover_timer_timeout() -> void:
	hover = false
