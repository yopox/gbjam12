extends Node

var player_board: Dictionary
var shop_level: int
var turn: int
var shop_l_locked: bool
var shop_r_locked: bool


func _ready() -> void:
	reset()
	
	
func reset() -> void:
	player_board = {}
	shop_level = 1
	turn = 1
	shop_l_locked = true
	shop_r_locked = true
