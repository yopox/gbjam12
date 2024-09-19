class_name Slot extends Node2D

@onready var border = $ColorRect
@onready var tower_node: TowerNode = $Tower
@onready var reaction = $Reaction

@onready var stats = $Stats
@onready var atk = $Stats/ATK
@onready var hp = $Stats/HP

@onready var lock = $Lock

@export var column: int
@export var row: int
@export var locked: bool
var team: int

enum State { Idle, Active }
enum Reaction { Exclamation, Death, Boost, Nerf }

var state = State.Idle : set = _set_state
var reaction_id: int = 0

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")


func _ready():
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_stats_changed.connect(_on_tower_stats_changed)
	FightUtil.tower_hide.connect(_on_tower_hide)
	FightUtil.tower_reaction.connect(_on_tower_reaction)
	reaction.texture = reaction.texture.duplicate()
	update_rect()


func set_tower(tower: Tower, t: int) -> void:
	self.team = t
	
	if tower == null:
		tower_node.empty = true
		tower_node.tower = null
		stats.visible = false
	else:
		tower_node.empty = false
		tower_node.tower = tower
		tower_node.tower.set_slot(self)
		tower_node.tower.team = t
		update_stats(tower)
		stats.visible = true
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


func _on_tower_hide(tower: Tower):
	if not match_tower(tower): return
	stats.visible = false


func update_rect() -> void:
	match state:
		State.Idle: border.color = Palette.DARK_GRAY
		State.Active: border.color = Palette.LIGHT_GRAY
	lock.visible = locked


func update_stats(tower: Tower) -> void:
	hp.text = str(tower.HP)
	atk.text = str(tower.ATK)


func activate() -> void:
	tower_node.activate()


func shoot(_tower: Tower, damage: int) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.damage = damage
	bullet.position = global_position + Vector2(8, 8)
	bullet.dir = 0.0 if team == 0 else PI
	bullet.team = team
	bullet.z_index = Values.BULLET_Z
	FightUtil.bullet_shot.emit()
	get_parent().add_sibling.call_deferred(bullet)


func _on_tower_reaction(tower: Tower, r: Reaction) -> void:
	if not match_tower(tower): return
	match r:
		Reaction.Exclamation: reaction.texture.region.position.x = 0
		Reaction.Death: reaction.texture.region.position.x = 8
		Reaction.Boost: reaction.texture.region.position.x = 8 * 2
		Reaction.Nerf: reaction.texture.region.position.x = 8 * 3
	reaction.visible = true
	reaction_id += 1
	var id = reaction_id
	await Util.wait(Values.REACTION)
	if reaction_id == id: reaction.visible = false
