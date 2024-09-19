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
	turn = 8
	shop_l_locked = true
	shop_r_locked = true

	
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
		writer.write_int(tower.type, 6)
		writer.write_int(min(tower.ATK, 1023), 10)
		writer.write_int(min(tower.HP, 1023), 10)
	
	return Marshalls.raw_to_base64(writer.get_byte_array())

	
func import_board(board: String) -> Dictionary:
	var read_board: Dictionary = {}
	
	var reader: BitReader = BitReader.new()
	var data: PackedByteArray = Marshalls.base64_to_raw(board)
	reader.set_byte_array(data)
	
	var presence: int = reader.read_int(8)
	
	for i in range(8):
		if presence & (2 ** i) != 0:
			var type: int = reader.read_int(6)
			var atk: int = reader.read_int(9)
			var hp: int = reader.read_int(9)
			var tower: Tower = Tower.new(type)
			tower.ATK = atk
			tower.HP = hp
			read_board[i] = tower
#			print("Tower %s : %s %s/%s" % [i, type, atk, hp])
	
	return read_board
