extends CharacterBody2D

@export var gravity_multiplier: float = 0.5

@export var SPEED = 2000.0
@export var JUMP_VELOCITY = -400.0

var direction = 1
enum states {idle, patrol}
var current_state = states.idle

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var visibility_cast_right: RayCast2D = $VisibilityCastRight
@onready var visibility_cast_left: RayCast2D = $VisibilityCastLeft
@onready var jump_cast: RayCast2D = $JumpCast


func process_animation():
	if velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * delta
		
	if visibility_cast_right.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		current_state = states.patrol
	elif visibility_cast_left.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
		current_state = states.patrol
	else:
		current_state = states.idle
	
	if current_state == states.patrol:
		velocity.x = direction * SPEED * delta
	
	process_animation()
	
	move_and_slide()
