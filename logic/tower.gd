class_name Tower extends Node

enum Type { S1_1, S2_1, K1_1, K2_1, G1_1, G2_1, G4_1, P1_1, P1_2, P2_1, P3_1, P4_1 }
enum Class { Spider, Skeleton, Ghost, Pumpkin }

var team: int
var column: int
var row: int

var type: Type: set = _set_type
var HP: int
var ATK: int


func set_slot(slot: Slot) -> void:
	column = slot.column
	row = slot.row


func _set_type(t: Type) -> void:
	type = t
	var stats = FightUtil.base_stats(t)
	ATK = stats[0]
	HP = stats[1]


func activate() -> void:
	if HP <= 0: return
	if FightUtil.shoots(type):
		FightUtil.tower_shoot.emit(self, ATK)


func clone() -> Tower:
	var t = Tower.new()
	t.type = type
	t.HP = HP
	t.ATK = ATK
	return t


func hit(damage: int) -> void:
	var d = min(HP, damage)
	HP -= d
	FightUtil.tower_hit.emit(self, d)
	print("[%s %s-%s] Hit for %s (%s HP left)" % [team, column, row, d, HP])
