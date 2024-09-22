extends Node

enum GameState { Shop, Fight, Collection, GameOver }

var state: GameState = GameState.Fight: set = _set_state

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
signal state_changed()


func _set_state(value: Util.GameState) -> void:
	state_changed.emit()
	state = value


func wait(amount: float):
	await get_tree().create_timer(amount).timeout

	
func debug(text: String):
	if Values.DEBUG: print(text)
