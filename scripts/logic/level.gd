extends Node2D

@export var music_name: String = ""
@export var bgs_name: String = ""
@export var level_id: int = 0

@onready var player: CharacterBody2D = $Player
@onready var game_ui: CanvasLayer = $GameUI

func _ready() -> void:
	# if the checkpoint is not for the correct level, save the checkpoint to the beginning of the stage
	if SaveSystem.checkpoint_data.stage != level_id:
		SaveSystem.checkpoint_save(player.position.x, player.position.y)
	
	# set the stage we are at in the save system
	SaveSystem.current_data.stage = level_id
	
	# play the music for the stage
	if music_name == "" or bgs_name == null:
		AudioManager.stop_music()
	else:
		AudioManager.play_music(music_name)
		
	# play the bgs for the stage
	if bgs_name == "" or bgs_name == null:
		AudioManager.stop_bgs()
	else:
		AudioManager.play_bgs(bgs_name)
		
	# if we need to load checkpoint or not
	if SceneManager.load_checkpoint:
		# loads the checkpoint so that we start at the checkpoint when restarting
		SaveSystem.checkpoint_load(player)
	
	# if we have starting coordinates we apply them here
	player.position = SceneManager.starting_coords
	
	# set position after cutscene
	if GlobalManager.cutscene_starting_coordinates != Vector2(0,0):
		player.position = GlobalManager.cutscene_starting_coordinates
		GlobalManager.cutscene_starting_coordinates = Vector2(0,0)
	
	# make it true since we should load it.
	SceneManager.load_checkpoint = true
	
	# reset it's value
	SceneManager.starting_coords = Vector2(0,0)
	
	# Updates the Player HP to the stored value
	var i = GlobalManager.get_current_health()
	if i > 0:
		player.set_health(i)
	
	# update the UI to reflect the checkpoint data
	game_ui._ready()
