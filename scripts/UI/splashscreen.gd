extends Node2D

@export var world_name: String
@export var level_name: String

@onready var label: Label = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = world_name + "\n" + level_name
	await get_tree().create_timer(2).timeout
	queue_free()
