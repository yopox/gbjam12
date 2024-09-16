extends Node


func _ready():
	FightUtil.fight_start.connect(_on_fight_start)
	FightUtil.tower_destroyed.connect(_on_tower_destroyed)
	FightUtil.tower_hit.connect(_on_tower_hit)


func _on_fight_start() -> void:
	for t in FightUtil.get_all(Tower.Type.P2_1):
		t.boost(1, 1, false, false)
		for t2: Tower in FightUtil.adjacent_towers(t):
			t2.boost(1, 1, false, false)


func _on_tower_destroyed(tower: Tower) -> void:
	if tower.type == Tower.Type.S1_2:
		tower.HP_boost += 1
	
	for t: Tower in FightUtil.adjacent_towers(tower):
		if Tower.Class.Spider in FightUtil.tower_class(tower.type):
			if t.type == Tower.Type.S3_1:
				t.boost(1, 1, true, false)
		if t.type == Tower.Type.K3_1:
			FightUtil.tower_shoot.emit(t, t.ATK)


func _on_tower_hit(tower: Tower, damage: int) -> void:
	if tower.type == Tower.Type.MIRROR:
		FightUtil.tower_reaction.emit(tower, Slot.Reaction.Exclamation)
		FightUtil.tower_shoot.emit(tower, damage)
