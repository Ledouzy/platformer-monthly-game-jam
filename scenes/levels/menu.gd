extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("Level")
	AudioManager.stop_bgs()
