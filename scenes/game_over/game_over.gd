extends Node2D

@onready var board: Board = $Board
@onready var label = $Label

var clicked: bool = false


func _ready():
	if Progress.enemy_dead: label.text = "YOU WON! \\(0v0)/"
	Progress.heal_board()
	board.set_towers(Progress.player_board, false, 0)


func _process(_delta):
	if Input.is_action_just_pressed("a") and not clicked:
		Util.restart.emit()
		clicked = true
