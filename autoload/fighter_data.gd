extends Node

var fighter: Array[Variant] = ["QJEAgAA=",
							  "YJMAQCaAIAA=",
							  "YpCAwCaAIACQCAA=",
							  "YpKAIAJAIAmgCAA=",
							  "5tMAwCRgKACQCADoAoCaAIAA",
							  "9tIAwA6AKAmgCANkAICTgGACQCAA",
							  "/9IAwA6AKAmgCAAkAgBBACAkEDgNkAICggCA",
							  "/9CAwAJAIAOgCgNkAIBBACAIIDAKCAICSQBA",
							  "/9IAwAbAEAOgCgNkAIBBACAIYCgKCAICRQJA",
							  "/9IAwAbAEAOgCgNkAIBBACAIEDgKCAICTQFA",
							  "/9IAwAbAEAOgCgNkAIBBACAIUCQKCAICQwNA",
							  "/0VAgAbAEAOgCgNkAIBBACAIMDQKCAICSwDA",
							  "/0VAgAbAEAOgCgNkAIBBACAIcCwKCAICRwLA",
							  "/0VAgAbAEAOgCgNkAIBBACAICDwKCAICTwHA",
							  "/0VAgAbAEAOgCgNkAIBBACAISCIKCAICQIPA",]




func get_enemy_board(turn: int) -> Dictionary:
	var b = fighter[14] if turn > 14 else fighter[turn - 1]
	return Progress.import_board(b)
