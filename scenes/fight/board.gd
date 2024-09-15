class_name Board extends Node2D

@export var slots: Array[Slot]


func _ready():
	FightUtil.activate_column.connect(activate_column)


func set_towers(towers: Dictionary, flip: bool, team: int) -> void:
	for i in range(8):
		var key = i if not flip else (i + 4) % 8
		if not towers.has(i): slots[key].set_tower(null, team)
		else: slots[key].set_tower(towers[i], team)


func activate_column(c: int) -> void:
	for s in slots:
		if s.column == c:
			s.activate()
