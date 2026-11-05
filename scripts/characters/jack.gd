extends CharacterBody2D

@export var gravity_multiplier: float = 0.5

@export var SPEED = 2000.0
@export var JUMP_VELOCITY = -200.0
@export var starting_direction = -1

var direction = 1
enum states {idle, patrol}
var current_state = states.idle
var lock_animation = false
var can_jump = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var visibility_cast_right: ShapeCast2D = $VisibilityCastRight
@onready var visibility_cast_left: ShapeCast2D = $VisibilityCastLeft
@onready var jump_cast: ShapeCast2D = $JumpCast


func _ready() -> void:
	direction = starting_direction
	if direction < 0:
		animated_sprite.flip_h = true
		

func process_animation():
	if lock_animation:
		return
	if velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * delta
	else:
		can_jump = true
		lock_animation = false
		
	if visibility_cast_right.is_colliding():
		direction = 1
		jump_cast.target_position = Vector2(32,jump_cast.position.y)
		animated_sprite.flip_h = false
		current_state = states.patrol
	elif visibility_cast_left.is_colliding():
		direction = -1
		jump_cast.target_position = Vector2(-32,jump_cast.position.y)
		animated_sprite.flip_h = true
		current_state = states.patrol
	else:
		current_state = states.idle
		
	if jump_cast.is_colliding() and can_jump:
		animated_sprite.play("jump")
		play_sfx("JackJump")
		velocity.y = JUMP_VELOCITY
		can_jump = false
		lock_animation = true
	
	if current_state == states.patrol:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	process_animation()
	
	move_and_slide()
	
# play a sound by calling the audio manager
func play_sfx(sfx_name):
	AudioManager.play_sfx(sfx_name, 0, self.position)
	
