class_name Board extends Node2D

@onready var slot_1: Slot = $Slot1
@onready var slot_2: Slot = $Slot2
@onready var slot_3: Slot = $Slot3
@onready var slot_4: Slot = $Slot4
@onready var slot_5: Slot = $Slot5
@onready var slot_6: Slot = $Slot6
@onready var slot_7: Slot = $Slot7
@onready var slot_8: Slot = $Slot8


func activate_column(c: int) -> void:
	var columns = [[slot_1, slot_5], [slot_2, slot_6], [slot_3, slot_7], [slot_4, slot_8]]
	
	# Change slot state
	for i in range(len(columns)):
		var state = Slot.State.Active if i == c else Slot.State.Idle
		columns[i][0].state = state
		columns[i][1].state = state
	
	# TODO: Activate towers
