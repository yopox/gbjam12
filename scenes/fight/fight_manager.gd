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
	
	await Util.wait(Values.FIGHT_START_DELAY)
	FightUtil.fight_start.emit()
	await Util.wait(Values.FIGHT_ABILITES_DELAY)
	
	while not finished:
		# Enable next zone
		zone_1.visible = active_column == 0
		zone_2.visible = active_column == 1
		zone_3.visible = active_column == 2
		zone_4.visible = active_column == 3
		
		# Trigger towers
		FightUtil.activate_column.emit(active_column)
		
		# TODO: Fight end condition
		await Util.wait(Values.TURN_DELAY)
		active_column = (active_column + 1) % 4
