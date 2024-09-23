extends Node2D

@onready var logo = $Logo

@onready var new_game = $NewGame
@onready var tutorial = $Tutorial
@onready var enter_code = $EnterCode
@onready var palette = $Palette
@onready var sound = $Sound

@onready var cursor: Node2D = $Cursor

var elapsed: float = 0.0
var selected: int = 0
var choice: bool = false


func _ready():
	recolor_logo()
	update_cursor()
	update_labels()
	choice = false


func _process(delta):
	elapsed += delta
	for i in range(8):
		var label: Label = logo.get_child(i)
		label.position.y = sin(elapsed * 3 + PI / 3 * i) * 2
	
	if choice: return
	
	if Input.is_action_just_pressed("a"):
		a()
	elif Input.is_action_just_pressed("down"):
		selected = posmod(selected + 1, 5)
		update_cursor()
	elif Input.is_action_just_pressed("up"):
		selected = posmod(selected - 1, 5)
		update_cursor()


func recolor_logo() -> void:
	for i in range(8):
		var label: Label = logo.get_child(i)
		label.add_theme_color_override("font_color", [Palette.WHITE, Palette.LIGHT_GRAY, Palette.DARK_GRAY].pick_random())


func a() -> void:
	match selected:
		0:
			choice = true
			Util.start_game.emit()
		3:
			Palette.set_palette.emit((Palette.current_palette + 1) % Palette.Name.keys().size())
			recolor_logo()
			update_labels()
		4:
			Util.mute.emit()


func update_cursor():
	match selected:
		0: cursor.position = new_game.position + Vector2(-2, 3)
		1: cursor.position = tutorial.position + Vector2(-2, 3)
		2: cursor.position = enter_code.position + Vector2(-2, 3)
		3: cursor.position = palette.position + Vector2(-2, 3)
		4: cursor.position = sound.position + Vector2(-2, 3)


func update_labels():
	palette.text = "Palette: %s" % Palette.current_palette
