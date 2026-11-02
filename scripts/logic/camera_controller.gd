extends Camera2D


@export var player: CharacterBody2D
@export var camera_offset: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !player.is_dead():
		position = player.position + offset
