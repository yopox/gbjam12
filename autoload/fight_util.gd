extends Node

signal activate_column(column: int)
signal tower_shoot(tower: Tower, damage: int)
signal tower_hit(tower: Tower, damage: int)
signal tower_stats_up(tower: Tower, delta_atk: int, delta_hp)
signal tower_destroyed(tower: Tower)


var player_board = {}


func _ready():
	var t = Tower.new()
	t.type = Tower.Type.S1_1
	player_board[0] = t
	player_board[5] = t
	player_board[6] = t
	player_board[3] = t


func base_stats(type: Tower.Type) -> Array:
	match type:
		Tower.Type.S1_1: return [1, 3]
		Tower.Type.S2_1: return [2, 4]
		Tower.Type.K1_1: return [1, 2]
		Tower.Type.K2_1: return [1, 3]
		Tower.Type.G1_1: return [3, 1]
		Tower.Type.G2_1: return [1, 1]
		Tower.Type.G4_1: return [0, 1]
		Tower.Type.P1_1: return [1, 1]
		Tower.Type.P2_1: return [0, 2]
		Tower.Type.P3_1: return [1, 5]
		Tower.Type.P4_1: return [0, 10]
		_:
			printerr("Stats not defined")
			return [999, 999]


func tower_class(type: Tower.Type) -> Tower.Class:
	if type in [Tower.Type.S1_1, Tower.Type.S2_1]:
		return Tower.Class.Spider
	if type in [Tower.Type.K1_1, Tower.Type.K2_1]:
		return Tower.Class.Skeleton
	if type in [Tower.Type.G1_1, Tower.Type.G2_1, Tower.Type.G4_1]:
		return Tower.Class.Ghost
	return Tower.Class.Pumpkin


func shoots(type: Tower.Type) -> bool:
	return tower_class(type) != Tower.Class.Pumpkin
