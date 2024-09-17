class_name Shop extends Node2D

@onready var level = $Header/Level
@onready var coins = $Header/Coins
@onready var slots = $Content/Slots
@onready var board: Board = $Board
@onready var cursor = $Cursor

var selected: Array[int] = [0, 1]

#region Towers
var T1: Array[Variant] = [Tower.Type.S1_1, Tower.Type.S1_2,
						 Tower.Type.K1_1, Tower.Type.K1_2,
						 Tower.Type.G1_1, Tower.Type.G1_2,
						 Tower.Type.P1_1, Tower.Type.P1_2,
						 Tower.Type.ROCK]

var T2: Array[Tower.Type] = [Tower.Type.S2_1, Tower.Type.S2_2,
							Tower.Type.K2_1, Tower.Type.K2_2,
							Tower.Type.G2_1, Tower.Type.G2_2,
							Tower.Type.P2_1, Tower.Type.P2_2]

var T3: Array[Variant] = [Tower.Type.S3_1, Tower.Type.S3_2,
						 Tower.Type.K3_1, Tower.Type.K3_2,
						 Tower.Type.G3_1, Tower.Type.G3_2,
						 Tower.Type.P3_1, Tower.Type.P3_2,
						 Tower.Type.MIRROR]

var T4: Array[Variant] = [Tower.Type.S4_1, Tower.Type.S4_2,
						 Tower.Type.K4_1, Tower.Type.K4_2,
						 Tower.Type.G4_1, Tower.Type.G4_2,
						 Tower.Type.P4_1, Tower.Type.P4_2]
#endregion


func _ready():
	board.set_towers(FightUtil.player_board, false, 0)
	for s: Slot in slots.get_children():
		s.set_tower(null, 1)
	update_cursor()


func _process(_delta):
	if Input.is_action_just_pressed("up"):
		selected[1] = posmod(selected[1] - 1, 5)
		if selected[1] == 3: selected[0] *= 2
		if selected[1] == 0: selected[0] /= 2
		update_cursor()
	elif Input.is_action_just_pressed("down"):
		selected[1] = posmod(selected[1] + 1, 5)
		if selected[1] == 1: selected[0] *= 2
		if selected[1] == 4: selected[0] /= 2
		update_cursor()
	if Input.is_action_just_pressed("left"):
		selected[0] = posmod(selected[0] - 1, 4)
		if selected[1] in [0, 4] and selected[0] > 1: selected[0] = 0
		update_cursor()
	elif Input.is_action_just_pressed("right"):
		selected[0] = posmod(selected[0] + 1, 4)
		if selected[1] in [0, 4] and selected[0] > 1: selected[0] = 0
		update_cursor()


func update_cursor() -> void:
	var pos: Vector2 = Vector2.ZERO
	if selected[1] == 0 or selected[1] == 4: pos.x = 48 + selected[0] * 64
	else: pos.x = 36 + selected[0] * 32
	var y_pos: Array[int] = [34, 58, 92, 114, 136]
	pos.y = y_pos[selected[1]]
	cursor.position = pos


func reroll() -> void:
	pass
