extends Node

enum GameState { Shop, Fight }

var state: GameState = GameState.Fight


func wait(amount: float):
	await get_tree().create_timer(amount).timeout
