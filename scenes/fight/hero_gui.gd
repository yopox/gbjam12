class_name HeroGUI extends Area2D

@export var team: int
var HP: int


func _ready():
	FightUtil.hero_damaged.connect(_on_hero_damaged)


func _on_hero_damaged(t: int, damage: int) -> void:
	if team != t: return
	HP = max(0, HP - damage)
