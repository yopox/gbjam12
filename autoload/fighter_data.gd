extends Node

var fighter: Array[Variant] = ["QKAJAAAA",
							  "YKAJAAADgCAAAAA=",
							  "ZKAJAAADQAEAAA4AgAAAAA==",
							  "ZrAFgAADQAEAAA4AgAAAKAJAAAA=",
							  "9kgNEAACwBYAAA4AgAAAMgCAAADQAEAAAoAkAAAA",]


var enemy_board: Dictionary = {}
var enemy_life: int = Values.BASE_LIFE


func reset() -> void:
	enemy_life = Values.BASE_LIFE
	enemy_board.clear()


func update_enemy_board(turn: int):
	var b = fighter[4] if turn > 4 else fighter[turn - 1]
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
