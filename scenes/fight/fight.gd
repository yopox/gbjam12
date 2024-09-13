class_name Fight extends Node2D

signal start_fight()


func _ready():
	start_fight.emit()
