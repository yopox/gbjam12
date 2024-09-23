extends Node2D

@onready var board: Board = $Board
@onready var label = $Label
@onready var network_label = $NetworkLabel
@onready var code = $Code

var clicked: bool = false


func _ready():
	FighterData.board_uploaded.connect(_on_board_uploaded)
	if Progress.enemy_dead:
		label.text = "YOU WON! \\(0v0)/"
		code.visible = false
		FighterData.upload_board()
	else:
		code.visible = false
		FighterData.upload_board()
#		network_label.visible = false
	Progress.heal_board()
	board.set_towers(Progress.player_board, false, 0)


func _process(_delta):
	if Input.is_action_just_pressed("a") and not clicked:
		Util.restart.emit()
		clicked = true


func _on_board_uploaded(result: bool, content: String) -> void:
	network_label.visible = result
	network_label.text = "Board code:"
	code.visible = result
	code.show_code(content.to_int())
