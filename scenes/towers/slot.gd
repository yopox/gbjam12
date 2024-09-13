class_name Slot extends Node2D

@onready var border = $ColorRect


enum State { Idle, Active }


var state = State.Idle : set = _set_state


func _ready():
	update_rect()


func _set_state(value: State) -> void:
	state = value
	update_rect()


func update_rect() -> void:
	match state:
		State.Idle: border.color = Palette.DARK_GRAY
		State.Active: border.color = Palette.LIGHT_GRAY
