class_name FightManager extends Node

@onready var zone_1 = $"../Zones/Zone1"
@onready var zone_2 = $"../Zones/Zone2"
@onready var zone_3 = $"../Zones/Zone3"
@onready var zone_4 = $"../Zones/Zone4"

@onready var player_board: Board = $"../PlayerBoard"
@onready var enemy_board: Board = $"../EnemyBoard"


func _on_fight_start_fight():
	fight()


func fight():
	var finished = false
	var active_column = 0
	
	while not finished:
		# Enable next zone
		zone_1.visible = active_column == 0
		zone_2.visible = active_column == 1
		zone_3.visible = active_column == 2
		zone_4.visible = active_column == 3
		
		# Trigger towers
		player_board.activate_column(active_column)
		enemy_board.activate_column(active_column)
		
		# TODO: Fight end condition
		await Util.wait(2)
		active_column = (active_column + 1) % 4
