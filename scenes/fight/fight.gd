class_name Fight extends Node2D

@onready var player_board = $PlayerBoard
@onready var enemy_board = $EnemyBoard
@onready var camera_2d: Camera2D = $Camera2D

signal start_fight()

var shake_duration: float
var shake_intensity: float
var shake_time: float


func _ready():
	FighterData.update_enemy_board(Progress.turn)
	FightUtil.shake.connect(_on_shake)
	
	player_board.set_towers(Progress.player_board, false, 0)
	enemy_board.set_towers(FighterData.enemy_board, true, 1)
	
	start_fight.emit()


func _process(_delta):
	if shake_duration > 0.1:
		var t = (shake_duration - (Time.get_ticks_msec() - shake_time)) / shake_duration
		if t <= 0:
			camera_2d.offset = Vector2.ZERO
			shake_duration = 0.0
		else:
			var rx = randf_range(-1.0, 1.0) * shake_intensity
			var ry = randf_range(-1.0, 1.0) * shake_intensity
			camera_2d.offset = Vector2(rx, ry) * t
	

func _on_shake(dead: bool, damage: int):
	shake_duration = 2000.0 if dead else 350.0
	shake_intensity = 4.0 if dead else 1.0 + damage / 20.0
	shake_time = Time.get_ticks_msec()
