class_name Fight extends Node2D

@onready var player_board = $PlayerBoard
@onready var enemy_board = $EnemyBoard

signal start_fight()


func _ready():
	player_board.set_towers(FightUtil.player_board, false, 0)
	enemy_board.set_towers(FightUtil.enemy_board, true, 1)
	
	start_fight.emit()
