extends Node2D

@onready var title = $CanvasLayer/Title

@onready var spider_slots = $SpiderSlots
@onready var skeleton_slots = $SkeletonSlots
@onready var ghost_slots = $GhostSlots
@onready var pumpkin_slots = $PumpkinSlots
@onready var other_slots = $OtherSlots

var selected = [0, 0]


func _ready():
	var spiders = [Tower.Type.S1_1, Tower.Type.S1_2, Tower.Type.S2_1, Tower.Type.S2_2, Tower.Type.S3_1, Tower.Type.S3_2, Tower.Type.S4_1, Tower.Type.S4_2]
	var skeletons = [Tower.Type.K1_1, Tower.Type.K1_2, Tower.Type.K2_1, Tower.Type.K2_2, Tower.Type.K3_1, Tower.Type.K3_2, Tower.Type.K4_1, Tower.Type.K4_2]
	var ghosts = [Tower.Type.G1_1, Tower.Type.G1_2, Tower.Type.G2_1, Tower.Type.G2_2, Tower.Type.G3_1, Tower.Type.G3_2, Tower.Type.G4_1, Tower.Type.G4_2]
	var pumpkins = [Tower.Type.P1_1, Tower.Type.P1_2, Tower.Type.P2_1, Tower.Type.P2_2, Tower.Type.P3_1, Tower.Type.P3_2, Tower.Type.P4_1, Tower.Type.P4_2]
	var others = [Tower.Type.ROCK, Tower.Type.MIRROR]
	for i in range(8):
		spider_slots.get_child(i).set_tower(Tower.new(spiders[i]), 0)
		skeleton_slots.get_child(i).set_tower(Tower.new(skeletons[i]), 0)
		ghost_slots.get_child(i).set_tower(Tower.new(ghosts[i]), 0)
		pumpkin_slots.get_child(i).set_tower(Tower.new(pumpkins[i]), 0)
		if i < 2: other_slots.get_child(i).set_tower(Tower.new(others[i]), 0)
	
	update()


func update():
	for i in range(8):
		spider_slots.get_child(i).state = Slot.State.Active if selected == [i, 0] else Slot.State.Idle
		skeleton_slots.get_child(i).state = Slot.State.Active if selected == [i, 1] else Slot.State.Idle
		ghost_slots.get_child(i).state = Slot.State.Active if selected == [i, 2] else Slot.State.Idle
		pumpkin_slots.get_child(i).state = Slot.State.Active if selected == [i, 3] else Slot.State.Idle
		if i < 2: other_slots.get_child(i).state = Slot.State.Active if selected == [i, 4] else Slot.State.Idle
