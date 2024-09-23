extends Node2D

@onready var cursor: Node2D = $Cursor
@onready var code: Code = $Code
@onready var status: Label = $Status

var selected = [0, 0]
var exit: bool = false
var in_progress: bool = false
var c: Array[int] = [0, 0, 0, 0, 0, 0]


func _ready():
	status.visible = false
	FighterData.board_retrieved.connect(_on_board_retrieved)
	update_cursor()


func _process(_delta):
	if exit: return
	
	if Input.is_action_just_pressed("left"):
		if selected[1] == 0: selected[0] = posmod(selected[0] - 1, 6)
		Util.play_sfx.emit(SFX.Sfx.Select)
		update_cursor()
	elif Input.is_action_just_pressed("right"):
		if selected[1] == 0: selected[0] = posmod(selected[0] + 1, 6)
		Util.play_sfx.emit(SFX.Sfx.Select)
		update_cursor()
	elif Input.is_action_just_pressed("up"):
		selected[1] = posmod(selected[1] - 1, 3)
		Util.play_sfx.emit(SFX.Sfx.Select)
		update_cursor()
	elif Input.is_action_just_pressed("down"):
		selected[1] = posmod(selected[1] + 1, 3)
		Util.play_sfx.emit(SFX.Sfx.Select)
		update_cursor()
	elif Input.is_action_just_pressed("a"):
		a()
	elif Input.is_action_just_pressed("b"):
		exit = true
		Util.restart.emit()


func a():
	match selected[1]:
		0:
			c[selected[0]] = posmod(c[selected[0]] + 1, 4)
			update_code()
		1:
			if in_progress: return
			in_progress = true
			FighterData.get_board.emit(compute_code())
			status.visible = true
			status.text = "Downloading boards…"
		2:
			if in_progress: return
			in_progress = true
			FighterData.get_random_board.emit()
			status.visible = true
			status.text = "Downloading boards…"


func update_cursor():
	match selected[1]:
		0:
			cursor.position = Vector2(30 + 20 * selected[0], 50)
		1:
			cursor.position = Vector2(109, 89)
		2:
			cursor.position = Vector2(73, 105)


func compute_code() -> int:
	return c[0] + (c[1] << 2) + (c[2] << 4) + (c[3] << 6) + (c[4] << 8) + (c[5] << 10)


func update_code():
	code.show_code(compute_code())

	
func _on_board_retrieved(success: bool, content: String) -> void:
	if not success:
		status.text = content
		return
	else: status.visible = false
	
	var boards = JSON.parse_string(content)
	FighterData.current_fighter = boards
	Util.start_game.emit()
