extends Node

var fighter: Array[Variant] = ["QAkAgAA=",
							  "YAkAgATAIAA=",
							  "ZAkAgATAIAEwCAA=",
							  "ZgkAgATAIAEwCAEEAIA=",
							  "9gkAgAAAEAQAAgBMAgATAIAwYDAA",
							  "9gkAgAAAEAQAAgBMAgATAIAwYDAA"]


func get_enemy_board(turn: int) -> Dictionary:
	var b = fighter[5] if turn > 5 else fighter[turn - 1]
	return Progress.import_board(b)
