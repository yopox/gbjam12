extends Node

@warning_ignore("unused_signal")
signal fight_start()
@warning_ignore("unused_signal")
signal activate_column(column: int)
@warning_ignore("unused_signal")
signal tower_shoot(tower: Tower, damage: int)
@warning_ignore("unused_signal")
signal tower_hit(tower: Tower, damage: int)
@warning_ignore("unused_signal")
signal tower_stats_changed(tower: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool)
@warning_ignore("unused_signal")
signal tower_destroyed(tower: Tower)
@warning_ignore("unused_signal")
signal tower_hide(tower: Tower)
@warning_ignore("unused_signal")
signal tower_reaction(tower: Tower, reaction: Slot.Reaction)

var player_board: Dictionary = {}
var enemy_board: Dictionary = {}


func _ready():
	enemy_board[0] = Tower.new(Tower.Type.S1_1)
	enemy_board[1] = Tower.new(Tower.Type.S1_1)
	player_board[0] = Tower.new(Tower.Type.S1_1)
	player_board[7] = Tower.new(Tower.Type.P3_1)


func adjacent_towers(tower: Tower) -> Array:
	var board = player_board if tower.team == 0 else enemy_board
	var adjacent = []
	var col = tower.column
	var row = tower.row
	var i = col + row * 4
	if col > 0 and board.has(i - 1): adjacent.append(board[i - 1])
	if col < 3 and board.has(i + 1): adjacent.append(board[i + 1])
	if row == 0 and board.has(i + 4): adjacent.append(board[i + 4])
	if row == 1 and board.has(i - 4): adjacent.append(board[i - 4])
	return adjacent


func base_stats(type: Tower.Type) -> Array:
	match type:
		Tower.Type.S1_1: return [2, 2]
		Tower.Type.S1_2: return [1, 1]
		Tower.Type.S2_1: return [2, 4]
		Tower.Type.S2_2: return [2, 3]
		Tower.Type.S3_1: return [4, 3]
		Tower.Type.S3_2: return [4, 4]
		Tower.Type.S4_1: return [5, 5]
		Tower.Type.S4_2: return [5, 3]

		Tower.Type.K1_1: return [3, 1]
		Tower.Type.K1_2: return [2, 1]
		Tower.Type.K2_1: return [1, 2]
		Tower.Type.K2_2: return [1, 3]
		Tower.Type.K3_1: return [4, 4]
		Tower.Type.K3_2: return [1, 5]
		Tower.Type.K4_1: return [3, 8]
		Tower.Type.K4_2: return [3, 6]

		Tower.Type.G1_1: return [2, 1]
		Tower.Type.G1_2: return [1, 1]
		Tower.Type.G2_1: return [3, 1]
		Tower.Type.G2_2: return [2, 1]
		Tower.Type.G3_1: return [5, 1]
		Tower.Type.G3_2: return [4, 1]
		Tower.Type.G4_1: return [0, 1]
		Tower.Type.G4_2: return [6, 1]

		Tower.Type.P1_1: return [3, 2]
		Tower.Type.P1_2: return [1, 1]
		Tower.Type.P2_1: return [2, 2]
		Tower.Type.P2_2: return [2, 4]
		Tower.Type.P3_1: return [1, 5]
		Tower.Type.P3_2: return [4, 4]
		Tower.Type.P4_1: return [0, 10]
		Tower.Type.P4_2: return [7, 7]

		Tower.Type.ROCK: return [0, 5]
		Tower.Type.MIRROR: return [0, 8]
		_:
			printerr("Stats not defined")
			return [999, 999]


func tower_sprite_x(type: Tower.Type) -> int:
	match type:
		Tower.Type.S1_1: return 0 * 16
		Tower.Type.S1_2: return 0 * 16
		Tower.Type.S2_1: return 0 * 16
		Tower.Type.S2_2: return 0 * 16
		Tower.Type.S3_1: return 0 * 16
		Tower.Type.S3_2: return 0 * 16
		Tower.Type.S4_1: return 0 * 16
		Tower.Type.S4_2: return 0 * 16
		Tower.Type.K1_1: return 2 * 16
		Tower.Type.K1_2: return 2 * 16
		Tower.Type.K2_1: return 2 * 16
		Tower.Type.K2_2: return 2 * 16
		Tower.Type.K3_1: return 2 * 16
		Tower.Type.K3_2: return 2 * 16
		Tower.Type.K4_1: return 2 * 16
		Tower.Type.K4_2: return 2 * 16
		Tower.Type.G1_1: return 4 * 16
		Tower.Type.G1_2: return 4 * 16
		Tower.Type.G2_1: return 4 * 16
		Tower.Type.G2_2: return 4 * 16
		Tower.Type.G3_1: return 4 * 16
		Tower.Type.G3_2: return 4 * 16
		Tower.Type.G4_1: return 4 * 16
		Tower.Type.G4_2: return 4 * 16
		Tower.Type.P1_1: return 6 * 16
		Tower.Type.P1_2: return 6 * 16
		Tower.Type.P2_1: return 6 * 16
		Tower.Type.P2_2: return 6 * 16
		Tower.Type.P3_1: return 6 * 16
		Tower.Type.P3_2: return 6 * 16
		Tower.Type.P4_1: return 6 * 16
		Tower.Type.P4_2: return 6 * 16
		_: return 0


func tower_families(type: Tower.Type) -> Array:
	# Multiple
	if type == Tower.Type.K4_1: return [Tower.Family.Skeleton, Tower.Family.Spider]
	if type == Tower.Type.G2_1: return [Tower.Family.Ghost, Tower.Family.Skeleton]
	if type == Tower.Type.P2_2: return [Tower.Family.Pumpkin, Tower.Family.Skeleton]
	if type == Tower.Type.P3_2: return [Tower.Family.Pumpkin, Tower.Family.Ghost]
	if type == Tower.Type.P4_2: return [Tower.Family.Pumpkin, Tower.Family.Spider]
	# Single
	if type in [Tower.Type.S1_1, Tower.Type.S1_2, Tower.Type.S2_1, Tower.Type.S2_2, Tower.Type.S3_1, Tower.Type.S3_2, Tower.Type.S4_1, Tower.Type.S4_2]:
		return [Tower.Family.Spider]
	if type in [Tower.Type.K1_1, Tower.Type.K1_2, Tower.Type.K2_1, Tower.Type.K2_2, Tower.Type.K3_1, Tower.Type.K3_2, Tower.Type.K4_2]:
		return [Tower.Family.Skeleton]
	if type in [Tower.Type.G1_1, Tower.Type.G1_2, Tower.Type.G2_2, Tower.Type.G3_1, Tower.Type.G3_2, Tower.Type.G4_1, Tower.Type.G4_2]:
		return [Tower.Family.Ghost]
	if type in [Tower.Type.P1_1, Tower.Type.P1_2, Tower.Type.P2_1, Tower.Type.P3_1, Tower.Type.P4_1]:
		return [Tower.Family.Pumpkin]
	# No family
	return []


func shoots(type: Tower.Type) -> bool:
	var c: Array = tower_families(type)
	return len(c) > 0 and not Tower.Family.Pumpkin in c


func get_all(type: Tower.Type) -> Array:
	var found: Array = []
	for board in [player_board, enemy_board]:
		for i in range(8):
			if board.has(i) and board[i].type == type:
				found.append(board[i])
	return found
