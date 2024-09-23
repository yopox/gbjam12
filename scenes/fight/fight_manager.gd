class_name FightManager extends Node

@onready var player_board: Board = $"../PlayerBoard"
@onready var enemy_board: Board = $"../EnemyBoard"

var fight_over: bool = false
var bullets: int = 0


func _on_fight_start_fight():
	fight()


func fight():
	var finished = false
	var active_column = 3
	
	for i in range(4):
		await Util.wait(Values.FIGHT_REVEAL_DELAY)
		FightUtil.reveal.emit(i)
	
	FightUtil.fight_start.emit()
	
	var n_skip = 0
	var short_wait = true
	
	while not finished:
		active_column = (active_column + 1) % 4
		
		var column = FightUtil.get_column(active_column)
		var skip = true
		for tower: Tower in column:
			if tower.HP > 0 and FightUtil.shoots(tower.type): skip = false
		if skip:
			n_skip += 1
			if n_skip == 4:
				fight_over = true
				end_fight()
				return
			continue
		
		n_skip = 0
		
		await Util.wait(Values.FIGHT_START_DELAY if short_wait else Values.FIGHT_TURN_DELAY)
		short_wait = false
		
		# Trigger towers
		FightUtil.activate_column.emit(active_column)


func end_fight() -> void:
	await Util.wait(Values.FIGHT_DESTROY_BULLETS_DELAY)
	FightUtil.destroy_bullets.emit()
	await Util.wait(Values.FIGHT_END_DELAY)
	FightUtil.fight_end.emit()


func _on_enemy_zone_body_entered(body):
	var bullet: Bullet = body
	if bullet.arrow or bullet.team == 1: return
	damage_hero(1, bullet.damage, bullet)


func _on_hero_zone_body_entered(body):
	var bullet: Bullet = body
	if bullet.arrow or bullet.team == 0: return
	damage_hero(0, bullet.damage, bullet)


func damage_hero(team: int, damage: int, bullet: Bullet) -> void:
	FightUtil.hero_damaged.emit(team, damage)
	bullet.destroy()
	if not bullet.arrow:
		FightUtil.hero_shoot.emit(team, bullet.column)
