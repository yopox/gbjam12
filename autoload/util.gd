extends Node


func wait(amount: float):
	await get_tree().create_timer(amount).timeout
