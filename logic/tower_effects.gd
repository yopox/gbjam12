extends Node


func _ready():
	FightUtil.fight_start.connect(_on_fight_start)
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_destroyed.connect(_on_tower_destroyed)
	FightUtil.tower_hit.connect(_on_tower_hit)
	FightUtil.tower_stats_changed.connect(_on_tower_stats_changed)


func _on_fight_start() -> void:
	for t in FightUtil.get_all(Tower.Type.P2_1):
		t.boost(1, 1, false, false)
		for t2: Tower in FightUtil.adjacent_towers(t):
			t2.boost(1, 1, false, false)


func _on_tower_shoot(tower: Tower, damage: int) -> void:
	for t in FightUtil.get_all(Tower.Type.P3_1):
		if tower.team == t.team and tower.row == t.row:
			FightUtil.tower_reaction.emit(t, Slot.Reaction.Exclamation)
			tower.boost(1, 0, false, false)


func _on_tower_destroyed(tower: Tower) -> void:
	if tower.type == Tower.Type.S1_2:
		tower.boost(0, 1, true, false, false)
	
	if tower.type == Tower.Type.K1_2:
		tower.boost(1, 0, true, false, false)
	
	for t: Tower in FightUtil.adjacent_towers(tower):
		if Tower.Class.Spider in FightUtil.tower_class(tower.type):
			if t.type == Tower.Type.S3_1:
				t.boost(1, 1, true, false)
		if t.type == Tower.Type.K3_1:
			FightUtil.tower_shoot.emit(t, t.ATK)
	
	for t in FightUtil.get_all(Tower.Type.P4_2):
		if t.team == tower.team:
			tower.boost(2, 0, true, false, false)


func _on_tower_hit(tower: Tower, damage: int) -> void:
	if tower.type == Tower.Type.MIRROR:
		FightUtil.tower_reaction.emit(tower, Slot.Reaction.Exclamation)
		FightUtil.tower_shoot.emit(tower, damage)


func _on_tower_stats_changed(tower: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool) -> void:
	for t: Tower in FightUtil.adjacent_towers(tower):
		if t.type == Tower.Type.S4_2:
			t.boost(delta_atk, delta_hp, perma, secondary)
