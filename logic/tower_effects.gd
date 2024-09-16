extends Node


func _ready():
	FightUtil.fight_start.connect(_on_fight_start)
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_destroyed.connect(_on_tower_destroyed)
	FightUtil.tower_hit.connect(_on_tower_hit)
	FightUtil.tower_stats_changed.connect(_on_tower_stats_changed)


func _on_fight_start() -> void:
	if Util.state == Util.GameState.Collection: return
	effect_p2_1()


func _on_tower_shoot(tower: Tower, _damage: int) -> void:
	if Util.state == Util.GameState.Collection: return
	effect_p3_1(tower)


func _on_tower_destroyed(tower: Tower) -> void:
	if Util.state == Util.GameState.Collection: return
	if tower.type == Tower.Type.S1_2: effect_s1_2(tower)
	if tower.type == Tower.Type.K1_2: effect_k1_2(tower)
	effect_p4_2(tower)
	
	for t: Tower in FightUtil.adjacent_towers(tower):
		effect_s3_1(tower, t)
		if t.type == Tower.Type.K3_1: effect_k3_1(t, tower)


func _on_tower_hit(tower: Tower, damage: int) -> void:
	if Util.state == Util.GameState.Collection: return
	if tower.type == Tower.Type.MIRROR: effect_mirror(tower, damage)


func _on_tower_stats_changed(tower: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool) -> void:
	for adjacent: Tower in FightUtil.adjacent_towers(tower):
		if adjacent.type == Tower.Type.S4_2: effect_s4_2(adjacent, delta_atk, delta_hp, perma, secondary)


func effect_s1_2(tower: Tower) -> void:
	tower.boost(0, 1, true, false, false)


func effect_s3_1(tower: Tower, adjacent: Tower) -> void:
	if Tower.Family.Spider in FightUtil.tower_families(tower.type):
		if adjacent.type == Tower.Type.S3_1:
			adjacent.boost(1, 1, true, false)


func effect_s4_2(s4_2: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool) -> void:
	s4_2.boost(delta_atk, delta_hp, perma, secondary)


func effect_k1_2(k1_2: Tower) -> void:
	k1_2.boost(1, 0, true, false, false)


func effect_k3_1(k3_1: Tower, _adjacent: Tower) -> void:
	FightUtil.tower_shoot.emit(k3_1, k3_1.ATK)


func effect_p2_1() -> void:
	for t in FightUtil.get_all(Tower.Type.P2_1):
		t.boost(1, 1, false, false)
		for t2: Tower in FightUtil.adjacent_towers(t):
			t2.boost(1, 1, false, false)


func effect_p3_1(tower: Tower) -> void:
	for t in FightUtil.get_all(Tower.Type.P3_1):
		if tower.team == t.team and tower.row == t.row:
			FightUtil.tower_reaction.emit(t, Slot.Reaction.Exclamation)
			tower.boost(1, 0, false, false)


func effect_p4_2(tower: Tower) -> void:
	for adjacent in FightUtil.get_all(Tower.Type.P4_2):
		if adjacent.team == tower.team:
			tower.boost(2, 0, true, false, false)


func effect_mirror(tower: Tower, damage: int) -> void:
	FightUtil.tower_reaction.emit(tower, Slot.Reaction.Exclamation)
	FightUtil.tower_shoot.emit(tower, damage)
