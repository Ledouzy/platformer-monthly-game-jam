extends Area2D

@onready var game_ui: CanvasLayer = %GameUI


func _on_body_entered(body: Node2D) -> void:
	if game_ui == null:
		game_ui = $GameUI
	game_ui.add_point()
	queue_free()
	AudioManager.play_sfx("Coin", 0, position)
	
