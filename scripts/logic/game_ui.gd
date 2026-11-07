extends CanvasLayer

@onready var level: Node2D = $".."
@onready var player: CharacterBody2D = $"../Player"
@onready var health_label: Label = $HBoxContainer/HPLabel
@onready var coins_label: Label = $HBoxContainer/CoinsLabel
@onready var stage_label: Label = $HBoxContainer/LevelLabel


var score = 0
var max_health = -1
var health = -1
var stage_names: Array = ["1-1","1-2","1-3","1-4","2-1","2-2","2-3","2-4","3-1","3-2","3-3","3-4","4-1","4-2","4-3","4-4","5-1","5-2","6-1","6-2"] # and so on and so forth, yeah it's shit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get the number of coins from the save data
	score = SaveSystem.current_data.coins
	# update coins and health
	coins_label.text = str(score)
	health_label.text = str(player.get_health()) + "/" + str(player.get_max_health())
	stage_label.text = stage_names.get(level.level_id)


func update_ui():
	# update health in process, technically could just have a function to do that like for coins
	health_label.text = str(player.get_health()) + "/" + str(player.get_max_health())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_ui()
	
# add n coin to the counter, defaults to 1
func add_point(n: int = 1):
	# update score and save that value
	score += n
	SaveSystem.current_data.coins = score
	# display the new amount of coins
	coins_label.text = str(score)
	
