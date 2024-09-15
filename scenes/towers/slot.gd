class_name Slot extends Node2D

@onready var border = $ColorRect
@onready var tower_node: TowerNode = $Tower

@onready var stats = $Stats
@onready var atk = $Stats/ATK
@onready var hp = $Stats/HP

@export var column: int
@export var row: int
var team: int

enum State { Idle, Active }


var state = State.Idle : set = _set_state

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")


func _ready():
	FightUtil.tower_shoot.connect(_on_tower_shoot)
	FightUtil.tower_stats_changed.connect(_on_tower_stats_changed)
	FightUtil.tower_hide.connect(_on_tower_hide)
	stats.visible = false
	update_rect()


func set_tower(tower: Tower, t: int) -> void:
	self.team = t
	
	if tower == null:
		tower_node.empty = true
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
	if value == State.Active and not tower_node.is_alive(): return
	state = value
	update_rect()


func match_tower(tower: Tower) -> bool:
	return tower.column == column and tower.row == row and tower.team == team


func _on_tower_shoot(tower: Tower, damage: int) -> void:
	if not match_tower(tower): return
	if damage == 0: return
	shoot(tower, damage)
	state = State.Active
	await Util.wait(1)
	state = State.Idle


func _on_tower_stats_changed(tower: Tower, _datk: int, _dhp: int, _secondary: bool) -> void:
	if not match_tower(tower): return
	update_stats(tower)


func _on_tower_hide(tower: Tower):
	if not match_tower(tower): return
	stats.visible = false


func update_rect() -> void:
	match state:
		State.Idle: border.color = Palette.DARK_GRAY
		State.Active: border.color = Palette.LIGHT_GRAY


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
	get_parent().add_sibling(bullet)
