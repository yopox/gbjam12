extends Node

enum GameState { Title, EnterCode, Shop, Fight, Collection, GameOver }

var state: GameState = GameState.Fight: set = _set_state
var bgm: BGM

@warning_ignore("unused_signal")
signal set_palette(palette: Palette)
@warning_ignore("unused_signal")
signal show_collection()
@warning_ignore("unused_signal")
signal hide_collection()
@warning_ignore("unused_signal")
signal fight()
@warning_ignore("unused_signal")
signal game_over()
@warning_ignore("unused_signal")
signal restart()
@warning_ignore("unused_signal")
signal start_game()
@warning_ignore("unused_signal")
signal enter_code()
signal state_changed()
@warning_ignore("unused_signal")
signal play_sfx(sfx: SFX.Sfx)
@warning_ignore("unused_signal")
signal mute()


func _set_state(value: Util.GameState) -> void:
	state = value
	state_changed.emit()


func wait(amount: float):
	await get_tree().create_timer(amount).timeout

	
func debug(text: String):
	if Values.DEBUG: print(text)
