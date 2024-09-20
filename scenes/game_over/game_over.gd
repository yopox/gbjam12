extends Node2D

@onready var board: Board = $Board
@onready var label = $Label


func _ready():
	if Progress.won: label.text = "YOU WON!"
	board.set_towers(Progress.player_board, false, 0)


func _process(_delta):
	if Input.is_action_just_pressed("a"):
		Util.restart.emit()
