extends Node


func _ready():
	FightUtil.fight_start.connect(_on_fight_start)
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_destroyed.connect(_on_tower_destroyed)
	FightUtil.tower_hit.connect(_on_tower_hit)
	FightUtil.tower_stats_changed.connect(_on_tower_stats_changed)
	FightUtil.tower_ghostly.connect(_on_tower_ghostly)


func _on_fight_start() -> void:
	if Util.state == Util.GameState.Collection: return
	effect_p2_1()
	for s2_1: Tower in FightUtil.get_all(Tower.Type.S2_1):
		effect_s2_1(s2_1)
	for g1_2: Tower in FightUtil.get_all(Tower.Type.G1_2):
		effect_g1_2(g1_2)
	for g3_2: Tower in FightUtil.get_all(Tower.Type.G3_2):
		effect_g3_2(g3_2)
	for k4_2: Tower in FightUtil.get_all(Tower.Type.K4_2):
		effect_k4_2(k4_2)


func _on_tower_shoot(tower: Tower, _damage: int) -> void:
	if Util.state == Util.GameState.Collection: return
	effect_p3_1(tower)


func _on_tower_destroyed(tower: Tower) -> void:
	if Util.state == Util.GameState.Collection: return
	if tower.type == Tower.Type.S1_2: effect_s1_2(tower)
	if tower.type == Tower.Type.K1_2: effect_k1_2(tower)
	if tower.type == Tower.Type.COIN: effect_coin(tower)
	if tower.type == Tower.Type.BOMB: effect_bomb(tower)
	effect_p4_2(tower)
	
	for t: Tower in FightUtil.adjacent_towers(tower):
		effect_s3_1(tower, t)
		if tower.type == Tower.Type.G2_2: effect_g2_2(tower, t)
		if t.type == Tower.Type.K3_1: effect_k3_1(t, tower)
		if t.type == Tower.Type.G3_1: effect_g3_1(t, tower)


func _on_tower_hit(tower: Tower, damage: int, bullet: Bullet) -> void:
	if Util.state == Util.GameState.Collection: return
	if tower.type == Tower.Type.MIRROR: effect_mirror(tower, damage)
	if tower.type == Tower.Type.P4_1: effect_p4_1(tower, damage)
	if bullet.shot_by == Tower.Type.K2_1: effect_k2_1(tower)


func _on_tower_stats_changed(tower: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool) -> void:
	if tower.type == Tower.Type.K4_1: effect_k4_1(tower, delta_atk, delta_hp)
	for adjacent: Tower in FightUtil.adjacent_towers(tower):
		if adjacent.type == Tower.Type.S3_2: effect_s3_2(adjacent, tower, delta_atk, delta_hp, perma, secondary)
		if adjacent.type == Tower.Type.S4_2: effect_s4_2(adjacent, delta_atk, delta_hp, perma, secondary)


func _on_tower_ghostly(tower: Tower, ghostly: bool) -> void:
	if ghostly:
		for p3_2: Tower in FightUtil.get_all(Tower.Type.P3_2):
			effect_p3_2(p3_2, tower)
		for adjacent: Tower in FightUtil.adjacent_towers(tower):
			if adjacent.type == Tower.Type.G2_1: effect_g2_1(adjacent)
			if adjacent.type == Tower.Type.G4_2: effect_g4_2(adjacent)
	

func tower_built(tower: Tower) -> void:
	if tower.type == Tower.Type.K2_2: effect_k2_2(tower)
	if tower.type == Tower.Type.S2_2: effect_s2_2(tower)


func tower_moved() -> void:
	pass


func effect_s1_2(tower: Tower) -> void:
	tower.boost(0, 1, true, false, false)


func effect_s2_1(s2_1: Tower) -> void:
	for tower: Tower in FightUtil.get_row(s2_1.row, s2_1.team):
		tower.boost(1, 1, false, false, false)


func effect_s2_2(s2_2: Tower) -> void:
	var stolen: int = 0
	for adjacent: Tower in FightUtil.adjacent_towers(s2_2):
		if Tower.Family.Spider in FightUtil.tower_families(adjacent.type):
			var s: int = min(2, adjacent.ATK)
			stolen += s
			if s > 0: adjacent.boost(-s, 0, false, false, false)
	if stolen == 0: return
	s2_2.boost(stolen, 0, false, false, false)


func effect_s3_1(tower: Tower, adjacent: Tower) -> void:
	if Tower.Family.Spider in FightUtil.tower_families(tower.type):
		if adjacent.type == Tower.Type.S3_1:
			adjacent.boost(1, 1, true, false)


func effect_s3_2(_s3_2: Tower, adjacent: Tower, delta_atk: int, _delta_hp: int, perma: bool, secondary: bool) -> void:
	if delta_atk <= 0: return
	adjacent.boost(0, delta_atk, perma, secondary)
	
	
func effect_s4_2(s4_2: Tower, delta_atk: int, delta_hp: int, perma: bool, secondary: bool) -> void:
	s4_2.boost(delta_atk, delta_hp, perma, secondary)


func effect_k1_2(k1_2: Tower) -> void:
	k1_2.boost(1, 0, true, false, false)


func effect_k2_1(shot: Tower) -> void:
	shot.boost(-1, 0, false, false, true)


func effect_k2_2(k2_2: Tower) -> void:
	var count: int = 0
	for tower: Tower in FightUtil.get_all_family(Tower.Family.Skeleton):
		if tower.team == k2_2.team:
			count += 1
	k2_2.boost(count, 0, false, false, false)


func effect_k3_1(k3_1: Tower, _adjacent: Tower) -> void:
	FightUtil.tower_shoot.emit(k3_1, k3_1.ATK)


func effect_k4_1(k4_1: Tower, delta_atk: int, delta_hp: int) -> void:
	if delta_atk <= 0 and delta_hp <= 0: return
	FightUtil.tower_shoot.emit(k4_1, k4_1.ATK)


func effect_k4_2(k4_2: Tower) -> void:
	k4_2.boost(k4_2.ATK, 0, false, false, true)


func effect_g1_2(g1_2: Tower) -> void:
	g1_2.make_ghostly()


func effect_g2_1(g2_1: Tower) -> void:
	FightUtil.tower_shoot.emit(g2_1, g2_1.ATK)

	
func effect_g2_2(_g2_2: Tower, adjacent: Tower) -> void:
	if Tower.Family.Ghost in FightUtil.tower_families(adjacent.type):
		adjacent.make_ghostly()


func effect_g3_1(g3_1: Tower, _adjacent: Tower) -> void:
	g3_1.make_ghostly()


func effect_g3_2(g3_2: Tower) -> void:
	for t: Tower in FightUtil.get_column(g3_2.column):
		if t != g3_2 and t.team == g3_2.team and t.row == g3_2.row - 1:
			g3_2.boost(t.ATK, t.HP, false, false, false)


func effect_g4_2(g4_2: Tower) -> void:
	g4_2.boost(1, 1, true, false, true)


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

			
func effect_p3_2(p3_2: Tower, ghostly: Tower) -> void:
	if ghostly.team == p3_2.team:
		ghostly.boost(1, 1, false, false, true)


func effect_p4_1(p4_1: Tower, damage: int) -> void:
	for adjacent: Tower in FightUtil.adjacent_towers(p4_1):
		adjacent.boost(damage, 0, false, false, true)


func effect_p4_2(tower: Tower) -> void:
	for p4_2 in FightUtil.get_all(Tower.Type.P4_2):
		if p4_2.team == tower.team:
			tower.boost(2, 0, true, false, false)


func effect_coin(coin: Tower) -> void:
	if coin.team == 0: Progress.coin_bonus += 1
		
	
func effect_bomb(bomb: Tower) -> void:
	FightUtil.tower_shoot.emit(bomb, bomb.ATK)


func effect_mirror(tower: Tower, damage: int) -> void:
	FightUtil.tower_reaction.emit(tower, Slot.Reaction.Exclamation)
	FightUtil.tower_shoot.emit(tower, damage)
