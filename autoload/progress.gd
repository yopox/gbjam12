extends Node

var player_board: Dictionary
var life: int
var shop_level: int
var turn: int
var shop_l_locked: bool
var shop_r_locked: bool
var coin_bonus: int
var player_dead: bool
var enemy_dead: bool
var t_id: int


func _ready() -> void:
	reset()
	
	
func reset() -> void:
	player_board = {}
	life = Values.BASE_LIFE
	shop_level = 1
	turn = 1
	shop_l_locked = true
	shop_r_locked = true
	coin_bonus = 0
	player_dead = false
	enemy_dead = false
	t_id = 0


func heal_board() -> void:
	for i in range(8):
		if not player_board.has(i): continue
		var tower: Tower = player_board[i]
		var base_stats = FightUtil.base_stats(tower.type)
		tower.ATK = base_stats[0] + tower.ATK_boost + tower.ATK_shop
		tower.HP = base_stats[1] + tower.HP_boost + tower.HP_shop


func export_board(board: Dictionary) -> String:
	var writer: BitWriter = BitWriter.new()

	var presence: int = 0
	for i in range(8):
		if board.has(i):
			presence += 2 ** i	
	writer.write_int(presence, 8)
	
	for i in range(8):
		if not board.has(i): continue
		var tower: Tower = board[i]
		writer.write_int(tower.t_id, 12)
		writer.write_int(tower.type, 6)
		writer.write_int(min(tower.ATK_shop, 1023), 10)
		writer.write_int(min(tower.HP_shop, 1023), 10)
	
	return Marshalls.raw_to_base64(writer.get_byte_array())

	
func import_board(board: String) -> Dictionary:
	var read_board: Dictionary = {}
	
	var reader: BitReader = BitReader.new()
	var data: PackedByteArray = Marshalls.base64_to_raw(board)
	reader.set_byte_array(data)
	
	var presence: int = reader.read_int(8)
	
	for i in range(8):
		if presence & (2 ** i) != 0:
			var id: int = reader.read_int(12)
			var type: int = reader.read_int(6)
			var atk: int = reader.read_int(10)
			var hp: int = reader.read_int(10)
			var tower: Tower = Tower.new(type)
			var stats = FightUtil.base_stats(type)
			tower.t_id = id
			tower.ATK = stats[0]
			tower.HP = stats[1]
			tower.ATK_shop = atk
			tower.HP_shop = hp
			read_board[i] = tower
			#print("Tower %s : %s %s/%s" % [i, type, atk, hp])
	
	return read_board
