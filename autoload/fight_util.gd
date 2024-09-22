extends Node

@warning_ignore("unused_signal")
signal fight_start()
@warning_ignore("unused_signal")
signal fight_end()
@warning_ignore("unused_signal")
signal activate_column(column: int)
@warning_ignore("unused_signal")
signal tower_shoot(tower: Tower, damage: int)
@warning_ignore("unused_signal")
signal tower_hit(tower: Tower, damage: int, bullet: Bullet)
@warning_ignore("unused_signal")
signal tower_stats_changed(tower: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool)
@warning_ignore("unused_signal")
signal tower_destroyed(tower: Tower)
signal destroy_tower(tower: Tower)
@warning_ignore("unused_signal")
signal tower_hide(tower: Tower)
@warning_ignore("unused_signal")
signal tower_reaction(tower: Tower, reaction: Slot.Reaction)
@warning_ignore("unused_signal")
signal hero_damaged(team: int, damage: int)
@warning_ignore("unused_signal")
signal hero_shoot(team: int, column: int)
@warning_ignore("unused_signal")
signal destroy_bullets()
@warning_ignore("unused_signal")
signal tower_ghostly(tower: Tower, ghostly: bool)


var enemy_board: Dictionary = {}
var enemy_life: int = Values.BASE_LIFE


func _ready():
	destroy_tower.connect(_on_destroy_tower)


func adjacent_towers(tower: Tower) -> Array:
	var board = Progress.player_board if tower.team == 0 else enemy_board
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

		Tower.Type.COIN: return [0, 1]
		Tower.Type.ROCK: return [0, 5]
		Tower.Type.BOMB: return [10, 1]
		Tower.Type.MIRROR: return [0, 12]
		_:
			printerr("Stats not defined")
			return [999, 999]


func tower_sprite_x(type: Tower.Type) -> int:
	match type:
		Tower.Type.S1_1: return 0 * 16
		Tower.Type.S1_2: return 2 * 16
		Tower.Type.S2_1: return 4 * 16
		Tower.Type.S2_2: return 6 * 16
		Tower.Type.S3_1: return 8 * 16
		Tower.Type.S3_2: return 10 * 16
		Tower.Type.S4_1: return 12 * 16
		Tower.Type.S4_2: return 14 * 16
		Tower.Type.K1_1: return 16 * 16
		Tower.Type.K1_2: return 18 * 16
		Tower.Type.K2_1: return 20 * 16
		Tower.Type.K2_2: return 22 * 16
		Tower.Type.K3_1: return 24 * 16
		Tower.Type.K3_2: return 26 * 16
		Tower.Type.K4_1: return 28 * 16
		Tower.Type.K4_2: return 30 * 16
		Tower.Type.G1_1: return 32 * 16
		Tower.Type.G1_2: return 34 * 16
		Tower.Type.G2_1: return 36 * 16
		Tower.Type.G2_2: return 38 * 16
		Tower.Type.G3_1: return 40 * 16
		Tower.Type.G3_2: return 42 * 16
		Tower.Type.G4_1: return 44 * 16
		Tower.Type.G4_2: return 46 * 16
		Tower.Type.P1_1: return 48 * 16
		Tower.Type.P1_2: return 50 * 16
		Tower.Type.P2_1: return 52 * 16
		Tower.Type.P2_2: return 54 * 16
		Tower.Type.P3_1: return 56 * 16
		Tower.Type.P3_2: return 58 * 16
		Tower.Type.P4_1: return 60 * 16
		Tower.Type.P4_2: return 62 * 16
		Tower.Type.COIN: return 64 * 16
		Tower.Type.ROCK: return 65 * 16
		Tower.Type.BOMB: return 66 * 16
		Tower.Type.MIRROR: return 67 * 16
		_: return 0


func tower_families(type: Tower.Type) -> Array:
	# Multiple
	if type == Tower.Type.K4_1: return [Tower.Family.Skeleton, Tower.Family.Spider]
	if type == Tower.Type.G2_1: return [Tower.Family.Ghost, Tower.Family.Skeleton]
	if type == Tower.Type.P3_2: return [Tower.Family.Pumpkin, Tower.Family.Ghost]
	if type == Tower.Type.P4_2: return [Tower.Family.Pumpkin, Tower.Family.Spider]
	# Single
	if type in [Tower.Type.S1_1, Tower.Type.S1_2, Tower.Type.S2_1, Tower.Type.S2_2, Tower.Type.S3_1, Tower.Type.S3_2, Tower.Type.S4_1, Tower.Type.S4_2]:
		return [Tower.Family.Spider]
	if type in [Tower.Type.K1_1, Tower.Type.K1_2, Tower.Type.K2_1, Tower.Type.K2_2, Tower.Type.K3_1, Tower.Type.K3_2, Tower.Type.K4_2]:
		return [Tower.Family.Skeleton]
	if type in [Tower.Type.G1_1, Tower.Type.G1_2, Tower.Type.G2_2, Tower.Type.G3_1, Tower.Type.G3_2, Tower.Type.G4_1, Tower.Type.G4_2]:
		return [Tower.Family.Ghost]
	if type in [Tower.Type.P1_1, Tower.Type.P1_2, Tower.Type.P2_1, Tower.Type.P2_2, Tower.Type.P3_1, Tower.Type.P4_1]:
		return [Tower.Family.Pumpkin]
	# No family
	return []


func tower_level(type: Tower.Type) -> int:
	if Values.T1.has(type): return 1
	if Values.T2.has(type): return 2
	if Values.T3.has(type): return 3
	return 4


func shoots(type: Tower.Type) -> bool:
	var c: Array = tower_families(type)
	return len(c) > 0 and not Tower.Family.Pumpkin in c


func get_combined_boards() -> Array:
	var found: Array = []
	for board in [Progress.player_board, enemy_board]:
		for i in range(8):
			if board.has(i):
				found.append(board[i])
	return found


func get_all(type: Tower.Type) -> Array:
	var found: Array = []
	for board in [Progress.player_board, enemy_board]:
		for i in range(8):
			if board.has(i) and board[i].type == type:
				found.append(board[i])
	return found

	
func get_all_family(family: Tower.Family) -> Array:
	var found: Array = []
	for board in [Progress.player_board, enemy_board]:
		for i in range(8):
			if board.has(i) and family in tower_families(board[i].type):
				found.append(board[i])
	return found


func get_column(c: int) -> Array:
	var column: Array = []
	for board in [Progress.player_board, enemy_board]:
		for i in range(8):
			if board.has(i) and board[i].column == c:
				column.append(board[i])
	return column

	
func get_row(r: int, team: int) -> Array:
	var row = []
	var board = Progress.player_board if team == 0 else enemy_board
	for i in range(8):
		if board.has(i) and board[i].row == r:
			row.append(board[i])
	return row


func damage_hero(team: int, damage: int) -> void:
	if team == 0:
		Progress.life = max(0, Progress.life - damage)
		if Progress.life <= 0 and not Progress.enemy_dead and not Progress.player_dead:
			# TODO: Screen shake
			Progress.player_dead = true
			await Util.wait(Values.GAME_OVER_DELAY)
			FightUtil.destroy_bullets.emit()
			Util.game_over.emit()
	else:
		enemy_life = max(0, enemy_life - damage)
		if enemy_life <= 0 and not Progress.enemy_dead and not Progress.player_dead:
			# TODO: Screen shake
			Progress.enemy_dead = true
			await Util.wait(Values.GAME_OVER_DELAY)
			FightUtil.destroy_bullets.emit()
			Util.game_over.emit()


func hero_life(team: int) -> int:
	return Progress.life if team == 0 else enemy_life


func _on_destroy_tower(tower: Tower) -> void:
	var board: Dictionary = Progress.player_board if tower.team == 0 else enemy_board
	for i in range(8):
		if board.has(i) and board[i] == tower:
			board.erase(i)
			return
