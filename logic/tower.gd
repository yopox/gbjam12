class_name Tower extends Node

enum Type {
	S1_1, S1_2, S2_1, S2_2, S3_1, S3_2, S4_1, S4_2,
	K1_1, K1_2, K2_1, K2_2, K3_1, K3_2, K4_1, K4_2,
	G1_1, G1_2, G2_1, G2_2, G3_1, G3_2, G4_1, G4_2,
	P1_1, P1_2, P2_1, P2_2, P3_1, P3_2, P4_1, P4_2,
	COIN, ROCK, BOMB, MIRROR
}
enum Family { Spider, Skeleton, Ghost, Pumpkin }

var team: int
var column: int
var row: int

var type: Type: set = _set_type
var HP: int
var ATK: int
var ghostly: bool
var effects_perma: bool

var HP_boost: int = 0
var ATK_boost: int = 0
var t_id: int


func _init(tower_type: Type):
	type = tower_type
	ghostly = false
	effects_perma = false
	t_id = Progress.t_id
	Progress.t_id += 1


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


func boost(atk: int, hp: int, perma: bool, secondary: bool, alive_only: bool = true) -> void:
	if alive_only and HP <= 0: return
	
	# Update current stats
	var atk_diff: int = atk
	if ATK + atk < 0: atk_diff = -ATK
	ATK += atk_diff
	if HP > 0: HP += hp
	
	# Fight boosts (discarded when exporting boards)
	if perma or effects_perma or type == Type.K3_2: ATK_boost += atk_diff
	if perma or effects_perma or type == Type.P1_2: HP_boost += hp
	
	FightUtil.tower_stats_changed.emit(self, atk_diff, hp, perma, secondary)
	FightUtil.tower_reaction.emit(self, Slot.Reaction.Boost if atk_diff >= 0 and hp >= 0 else Slot.Reaction.Nerf)


func hit(bullet: Bullet) -> void:
	if ghostly and not bullet.arrow:
		ghostly = false
		FightUtil.tower_ghostly.emit(self, false)
		return
	var damage = bullet.damage
	var d = min(HP, damage)
	HP -= d
	FightUtil.tower_hit.emit(self, d, bullet)
	FightUtil.tower_stats_changed.emit(self, 0, -d, false, false)
	#print("[%s %s-%s] Hit for %s (%s HP left)" % [team, column, row, d, HP])
	if HP <= 0:
		die()
	else:
		Util.play_sfx.emit(SFX.Sfx.Hit)
	if Family.Pumpkin in FightUtil.tower_families(type):
		if HP > 0: FightUtil.tower_reaction.emit(self, Slot.Reaction.Exclamation)
		await Util.wait(Values.PUMPKIN_DELAY)
		FightUtil.tower_shoot.emit(self, ATK)


func kill() -> void:
	HP = 0
	die()


func make_ghostly() -> void:
	if ghostly: return
	ghostly = true
	FightUtil.tower_reaction.emit(self, Slot.Reaction.Ghost)
	FightUtil.tower_ghostly.emit(self, true)


func die() -> void:
	FightUtil.tower_destroyed.emit(self)
	FightUtil.tower_reaction.emit(self, Slot.Reaction.Death)
