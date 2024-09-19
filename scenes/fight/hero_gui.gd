class_name HeroGUI extends Area2D

@export var team: int
@onready var hp_label = $Node2D/Label
@onready var bg = $BG
@onready var life_bar = $Life

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")


func _ready():
	FightUtil.hero_damaged.connect(_on_hero_damaged)
	FightUtil.hero_shoot.connect(_on_hero_shoot)
	update()


func _on_hero_damaged(t: int, damage: int) -> void:
	if team != t: return
	if t == 0: Input.vibrate_handheld(Values.VIBRATION_DURATION, -1)
	FightUtil.damage_hero(t, damage)
	update()


func update() -> void:
	var life = FightUtil.hero_life(team)
	hp_label.text = "%s" % life
	life_bar.size.x = life * bg.size.x / Values.BASE_LIFE 


func _on_hero_shoot(t: int, column: int) -> void:
	if team != t: return
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.damage = Progress.turn
	bullet.position = Vector2(32 * (column + 1), -8 if t == 1 else 152)
	bullet.dir = 0.0 if t == 0 else PI
	bullet.team = team
	bullet.column = column
	bullet.z_index = Values.BULLET_Z
	bullet.arrow = true
	get_parent().add_sibling.call_deferred(bullet)
