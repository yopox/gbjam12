class_name Board extends Node2D

@export var slots: Array[Slot]

var flipped: bool = false


func _ready():
	FightUtil.activate_column.connect(activate_column)


func set_towers(towers: Dictionary, flip: bool, team: int) -> void:
	flipped = flip
	
	for i in range(8):
		if not towers.has(i): continue
		var t: Tower = towers[i]
		var stats = FightUtil.base_stats(t.type)
		t.ATK = stats[0] + t.ATK_boost
		t.HP = stats[1] + t.HP_boost

	for i in range(8):
		var key = i if not flip else (i + 4) % 8
		@warning_ignore("integer_division")
		slots[key].row = i / 4
		if not towers.has(i):
			slots[key].set_tower(null, team)
		else:
			slots[key].set_tower(towers[i], team)


func get_tower(row: int, column: int) -> Tower:
	var i = row + 4 * column
	var key = i if not flipped else (i + 4) % 8
	return slots[key].tower


func activate_column(c: int) -> void:
	for s in slots:
		if s.column == c:
			s.activate()


func lock(turn: int) -> void:
	for i in range(8):
		var slot: Slot = get_child(i)
		slot.locked = turn < Values.LOCKS[i]
		slot.update_rect()
