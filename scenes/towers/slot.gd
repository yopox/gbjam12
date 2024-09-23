class_name Slot extends Node2D

@onready var border = $ColorRect
@onready var tower_node: TowerNode = $Tower
@onready var reaction = $Reaction
@onready var particles = $Particles
@onready var hide_reaction = $HideReaction
@onready var reveal: Sprite2D = $Reveal
@onready var reveal_animation: AnimationPlayer = $Reveal/RevealAnimation

@onready var stats = $Stats
@onready var atk = $Stats/ATK
@onready var hp = $Stats/HP

@onready var lock = $Lock

@export var column: int
@export var row: int
@export var locked: bool
var team: int

enum State { Idle, Active }
enum Reaction { Exclamation, Death, Boost, Nerf, Ghost }

var state = State.Idle : set = _set_state
var reaction_id: int = 0

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")


func _ready():
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_stats_changed.connect(_on_tower_stats_changed)
	FightUtil.tower_hide.connect(_on_tower_hide)
	FightUtil.tower_reaction.connect(_on_tower_reaction)
	FightUtil.destroy_tower.connect(_on_destroy_tower)
	FightUtil.reveal.connect(_on_reveal)
	reaction.texture = reaction.texture.duplicate()
	update_rect()
	
	if Util.state == Util.GameState.Fight:
		reveal.visible = true
		reveal.texture = reveal.texture.duplicate()


func set_tower(tower: Tower, t: int) -> void:
	self.team = t
	stats.visible = tower != null and Util.state != Util.GameState.Fight
	
	if tower == null:
		tower_node.empty = true
		tower_node.tower = null
	else:
		tower_node.empty = false
		tower_node.tower = tower
		tower_node.tower.set_slot(self)
		tower_node.tower.team = t
		update_stats(tower)
	
	if Util.state == Util.GameState.Fight:
		tower_node.visible = false
		reveal.visible = tower != null
		if tower != null: reveal.texture.region.position.x = reveal_x()
		
	tower_node.update()


func _set_state(value: State) -> void:
	if value == State.Active and not should_highlight(): return
	state = value
	update_rect()


func should_highlight() -> bool:
	return Util.state == Util.GameState.Fight and tower_node.is_alive() \
		or Util.state != Util.GameState.Fight


func match_tower(tower: Tower) -> bool:
	if tower == null: return false
	return tower.team == team and tower.column == column and tower.row == row


func _on_tower_shoot(tower: Tower, damage: int) -> void:
	if not match_tower(tower): return
	if damage == 0: return
	shoot(tower, damage)
	state = State.Active
	await Util.wait(1)
	state = State.Idle


func _on_tower_stats_changed(tower: Tower, _datk: int, _dhp: int, _perma: bool, _secondary: bool) -> void:
	if not match_tower(tower): return
	update_stats(tower)


func _on_tower_hide(tower: Tower) -> void:
	if not match_tower(tower): return
	stats.visible = false
	particles.emitting = true


func _on_destroy_tower(tower: Tower) -> void:
	if not match_tower(tower): return
	stats.visible = false
	particles.emitting = true


func update_rect() -> void:
	match state:
		State.Idle: border.color = Palette.DARK_GRAY
		State.Active: border.color = Palette.LIGHT_GRAY
	lock.visible = locked


func update_stats(tower: Tower) -> void:
	hp.text = str(tower.HP)
	atk.text = str(tower.ATK)


func reveal_x() -> int:
	var families = FightUtil.tower_families(tower_node.tower.type)
	if len(families) == 0:
		reveal.visible = false
		tower_node.visible = true
		return 0
	else:
		match families[0]:
			Tower.Family.Spider: return 68 * 16
			Tower.Family.Skeleton: return 69 * 16
			Tower.Family.Ghost: return 70 * 16
			Tower.Family.Pumpkin: return 71 * 16
	return 0


func _on_reveal(c: int) -> void:
	if column != c or tower_node.tower == null or tower_node.tower.type in [Tower.Type.COIN, Tower.Type.ROCK, Tower.Type.BOMB, Tower.Type.MIRROR]: return
	reveal_animation.play("blink")


func reveal_end() -> void:
	reveal.visible = false
	stats.visible = tower_node.tower != null
	tower_node.visible = true


func activate() -> void:
	tower_node.activate()


func shoot(tower: Tower, damage: int) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.damage = damage
	bullet.position = global_position + Vector2(8, 8)
	bullet.dir = 0.0 if team == 0 else PI
	bullet.team = team
	bullet.column = column
	bullet.shot_by = tower.type
	bullet.z_index = Values.BULLET_Z
	get_parent().add_sibling.call_deferred(bullet)


func _on_tower_reaction(tower: Tower, r: Reaction) -> void:
	if not match_tower(tower): return
	match r:
		Reaction.Exclamation: reaction.texture.region.position.x = 0
		Reaction.Death: reaction.texture.region.position.x = 8
		Reaction.Boost: reaction.texture.region.position.x = 8 * 2
		Reaction.Nerf: reaction.texture.region.position.x = 8 * 3
		Reaction.Ghost: reaction.texture.region.position.x = 8 * 5
	reaction.visible = true
	reaction_id += 1
	hide_reaction.wait_time = Values.REACTION
	hide_reaction.start()


func _on_hide_reaction_timeout():
	reaction.visible = false
