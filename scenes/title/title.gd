extends Node2D

@onready var logo = $Logo

@onready var new_game = $NewGame
@onready var enter_code = $EnterCode
@onready var palette = $Palette
@onready var sound: Label = $Sound
@onready var version: Label = $Version

@onready var cursor: Node2D = $Cursor

var elapsed: float = 0.0
var selected: int = 0
var choice: bool = false


func _ready():
	recolor_logo()
	update_labels()
	update_cursor()
	version.text = "v%s" % ProjectSettings.get_setting("application/config/version")
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
		selected = posmod(selected + 1, 4)
		update_cursor()
		Util.play_sfx.emit(SFX.Sfx.Move)
	elif Input.is_action_just_pressed("up"):
		selected = posmod(selected - 1, 4)
		update_cursor()
		Util.play_sfx.emit(SFX.Sfx.Move)


func recolor_logo() -> void:
	for i in range(8):
		var label: Label = logo.get_child(i)
		label.add_theme_color_override("font_color", [Palette.WHITE, Palette.LIGHT_GRAY, Palette.DARK_GRAY].pick_random())


func a() -> void:
	Util.play_sfx.emit(SFX.Sfx.Select)
	match selected:
		0:
			choice = true
			FighterData.current_fighter = FighterData.fighters.pick_random()
			Util.start_game.emit()
		1:
			choice = true
			Util.enter_code.emit()
		2:
			Palette.set_palette.emit((Palette.current_palette + 1) % Palette.Name.keys().size())
			recolor_logo()
			update_labels()
		3:
			Util.mute.emit()
			update_labels()


func update_cursor():
	match selected:
		0: cursor.position = new_game.position + Vector2(-2, 3)
		1: cursor.position = enter_code.position + Vector2(-2, 3)
		2: cursor.position = palette.position + Vector2(-2, 3)
		3: cursor.position = sound.position + Vector2(-2, 3)


func update_labels():
	palette.text = "Palette: %s" % Palette.current_palette
	sound.text = "Sound: %s" % ("On" if not Util.bgm.mute else "Off")
