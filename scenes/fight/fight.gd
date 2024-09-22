class_name Fight extends Node2D

@onready var player_board = $PlayerBoard
@onready var enemy_board = $EnemyBoard

signal start_fight()


func _ready():
	FighterData.update_enemy_board(Progress.turn)
	
	player_board.set_towers(Progress.player_board, false, 0)
	enemy_board.set_towers(FighterData.enemy_board, true, 1)
	
	start_fight.emit()
