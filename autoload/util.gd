extends Node

enum GameState { Shop, Fight, Collection }

var state: GameState = GameState.Fight


func wait(amount: float):
	await get_tree().create_timer(amount).timeout
