extends CharacterBody2D

@export var gravity_multiplier: float = 0.2

@export var SPEED = 10.0
@export var JUMP_VELOCITY = -100.0
@export var MAX_SPEED = 50
@export var ROLL_SPEED = 50
@export var starting_direction = -1
@export var roll_slowdown = 100

var direction = 1
enum states {patrol, roll}
var current_state = states.patrol
var lock_animation = false
var can_jump = true
var rolling = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var visibility_cast_right: ShapeCast2D = $VisibilityCastRight
@onready var visibility_cast_left: ShapeCast2D = $VisibilityCastLeft
@onready var jump_cast: ShapeCast2D = $JumpCast
@onready var wall_check_right: RayCast2D = $WallCheckRight
@onready var wall_check_left: RayCast2D = $WallCheckLeft


func _ready() -> void:
	direction = starting_direction
	if direction < 0:
		animated_sprite.flip_h = true

func process_animation():
	if lock_animation:
		return
	if current_state == states.patrol:
		animated_sprite.play("walk")
	elif current_state == states.roll:
		animated_sprite.play("roll")
	else:
		animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * delta
	else:
		can_jump = true
		lock_animation = false
	if wall_check_right.is_colliding():
		# flip direction after hitting a wall
		direction = -1
		jump_cast.target_position = Vector2(-16,jump_cast.position.y)
		animated_sprite.flip_h = true
		# stops rolling if hits a wall
		rolling = false
		current_state = states.patrol
	elif wall_check_left.is_colliding():
		# flip direction after hitting a wall
		direction = 1
		jump_cast.target_position = Vector2(16,jump_cast.position.y)
		animated_sprite.flip_h = false
		# stops rolling if hits a wall
		rolling = false
		current_state = states.patrol
		
	if visibility_cast_right.is_colliding() and direction == 1:
		current_state = states.roll
	elif visibility_cast_left.is_colliding() and direction == -1:
		current_state = states.roll
		
	if jump_cast.is_colliding() and can_jump and current_state != states.roll:
		animated_sprite.play("jump")
		velocity.y = JUMP_VELOCITY
		can_jump = false
		lock_animation = true
	
	if current_state == states.patrol:
		print('walking')
		velocity.x += direction * SPEED * delta
		if abs(velocity.x) >= MAX_SPEED:
			velocity.x = move_toward(velocity.x, MAX_SPEED, SPEED*delta)
	elif current_state == states.roll and !rolling:
		print('roll start')
		rolling = true
		velocity.x += direction * ROLL_SPEED
		pass
	elif current_state == states.roll:
		print('rolling')
		#velocity.x = move_toward(velocity.x, 0, roll_slowdown)
		pass
	
	process_animation()
	
	move_and_slide()
