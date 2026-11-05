extends Node2D

@export var world_name: String
@export var level_name: String

@onready var label: Label = $CanvasLayer/Label
@onready var animation: AnimationPlayer = $TransitionAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	label.text = world_name + "\n" + level_name
	
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	
	# initiate fade in
	animation.play("fade_in")
	await animation.animation_finished
	queue_free()
