extends Node

var fighters: Array = [
		["QAAIAA==","YAAIMAJA","ZAAIMAJOAAQ=","ZgAIMAJOAAXANA==","9sAJAAIGgMKgEOAAXANA","9sAJAAIGgMKgEIQFnANA","/8AJAAIGgMKgEFQJIQFnANNQKg==","/8AJAAIGgMKgEFQJIQFnANNQKg==","/8AJLwHGgMKgENQKoQFgAIHANA==","/8AJLwHGgMKgENQKoQFmIPjICg==","/8AJLwHFoHqgENQKoQFmIPjICg==","/8AJLwHFoHqgENQKoQFmIPjICg=="],
		["QAAIgA==","YAAIiAJg","ZAAIiAJuAJA=","ZAAIiAJuAJA=","5GgIAAIiAJuAJA==","9mgIAAIngFgQFOAJCAJg","/2gIAAIngFgQFFQCLQECAJuAJA==","/2gIAAIngFuAJFQCLQECAJrwBg==","/5IKGgIHgFuAJFQCLQECAJnIPg==","/5IKJ4OHgFuAJFQCLQEFkGHIPg==","/5IKJ4OHgFuAJFkGFQCLQEJUKg==","/1QCJ4OHgFuAJFkGMMMLQEJUKg==","/7QEHgFqsHuAJFkGJ4OMMMJUKg==","/1cKKsHngFuAJFkGJ4OG8PpUKg=="],
		["IAABAA==","YMAIAABA","YsAIAABBABg=","ZsAIAABDAEBABg==","dsAIAABBABjAEKgMAA==","9rgMMAIAABBABjAEKgMA","/7gMMAIIwKBABpQCDAEKgMAABA==","/3wKDwCIwKLgMJQCDAEKgMMAIA==","/3wKDwCIwKLgMJQCDAEKgMMAIA==","/5oHjwCLgMJQCIwKDAEKgMMAIA==","/4wKJoHrgMJQCG4GDAEKgMMAIA==","/5QCJoHrgMBEMW4GDAEKgMMAIA==","/8AIBkKLgMBEMW4GJoHqgMDAEA==","/xEMRkKLgMG4GDAEJoHqgMKUKg==","/xEMW4GLgMDAEJoHmMKqgMKUKg=="], 
		["QAAIgA==","QAAIgA==","YBAMgAIg","ZhAMrAEAAIjAIg==","9igEBAMrAEMgAQAIjAIg","9igEBAMrAEMgAQAIjAIg","/5QEBAMrAEMgASgEAAIjAImQLg==","/5QEBAMmQLoIESgEAAIjAIsIKg==","/8oARAMmQLoIESgEAAIjAIsIKg==","//oOhAMmQLoIEUYGgAIjAIsIKg==","/wAIhAMmQLjYGkYGvoOjAIo4Gg==","/wAIhAMmQLjAIkYGo4GjYGvoOg==","//oOtECmQLjAIkYGo4GjYGgAIg==","//oOtECmQLgAIkYGo4GjYGpkKg==","//oOo4GmQLgAIg0KtECpUKpkKg=="],
		["QIAAQA==","QIAAQA==","YIAARAFg","ZLAMhAFvAFg=","9CgNrAMhAFhgNvAFgA==","9igNrAMhAFhgNvAFvgNA","/nQKLAMhAFhgNigNvAFvgNA=","/3QKLAMhAFhgNigNvAFvgNFwMA==","/3QKLAMhAFhgNigNuILiIOlwMA==","/3QKLAMhAFhgNnoGuILiIOtoDg==","/3QKLAMhAFhgNq4GOILiIOjYPg==","/6EKLAMhAFhgNq4GIEKiIOjYPg==","/64GLAMhAFhgNgUKoEKiIOjYPg==","/64GLAMhAFhgNgUKoEKiIOjYPg==","/64GLAMhAFhgNgUKgMOIEKiIOg==","/64GLAMhAFhgNgUKgMOIEKiIOg=="],
]
var current_fighter: Array = []
var hero_boards: Array = []

var enemy_board: Dictionary = {}
var enemy_life: int = Values.BASE_LIFE

signal upload()
@warning_ignore("unused_signal")
signal get_board(code: int)
@warning_ignore("unused_signal")
signal get_random_board()
@warning_ignore("unused_signal")
signal board_retrieved(board: String)
@warning_ignore("unused_signal")
signal board_uploaded(success: bool, content: String)


func reset() -> void:
	enemy_life = Values.BASE_LIFE
	current_fighter.clear()
	enemy_board.clear()
	hero_boards.clear()


func save(board: String) -> void:
	hero_boards.append(board)


func upload_board() -> void:
	upload.emit(JSON.stringify(hero_boards))


func update_enemy_board(turn: int):
	var tmax: int = len(current_fighter) - 1
	var b: String = current_fighter[tmax] if turn > tmax else current_fighter[turn - 1]
	var new_board = Progress.import_board(b)
	for i in range(8):
		if not new_board.has(i): continue
		var t1: Tower = new_board[i]
		for j in range(8):
			if not enemy_board.has(j): continue
			var t2: Tower = enemy_board[j]
			if t1.t_id == t2.t_id:
				t1.ATK_boost = t2.ATK_boost
				t1.HP_boost = t2.HP_boost
	enemy_board = new_board

	
func damage(d: int) -> bool:
	enemy_life = max(0, enemy_life - d)
	return enemy_life > 0
