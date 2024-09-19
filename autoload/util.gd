extends Node

enum GameState { Shop, Fight, Collection }

var state: GameState = GameState.Fight

signal set_palette(palette: Palette)
signal show_collection()
signal hide_collection()
signal fight()


func wait(amount: float):
	await get_tree().create_timer(amount).timeout
