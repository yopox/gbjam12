extends Node


func _ready():
	FightUtil.tower_destroyed.connect(_on_tower_destroyed)


func _on_tower_destroyed(tower: Tower):
	if tower.type == Tower.Type.S1_1:
		tower.HP_boost += 1
	
	for t: Tower in FightUtil.adjacent_towers(tower):
		if FightUtil.tower_class(tower.type) == Tower.Class.Spider:
			if t.type == Tower.Type.S3_1:
				t.boost(1, 1, true, false)
		if t.type == Tower.Type.K3_1:
			FightUtil.tower_shoot.emit(t, t.ATK)
