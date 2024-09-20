extends Node2D

@onready var title = $CanvasLayer/Title

@onready var slots: Node2D = $Slots
@onready var spider_slots = $Slots/SpiderSlots
@onready var skeleton_slots = $Slots/SkeletonSlots
@onready var ghost_slots = $Slots/GhostSlots
@onready var pumpkin_slots = $Slots/PumpkinSlots
@onready var other_slots = $Slots/OtherSlots

@onready var cursor: Node2D = $Cursor

@onready var shoot_timer: Timer = $ShootTimer

var selected = [0, 0]


func _ready():
	Util.state = Util.GameState.Collection
	
	var spiders = [Tower.Type.S1_1, Tower.Type.S1_2, Tower.Type.S2_1, Tower.Type.S2_2, Tower.Type.S3_1, Tower.Type.S3_2, Tower.Type.S4_1, Tower.Type.S4_2]
	var skeletons = [Tower.Type.K1_1, Tower.Type.K1_2, Tower.Type.K2_1, Tower.Type.K2_2, Tower.Type.K3_1, Tower.Type.K3_2, Tower.Type.K4_1, Tower.Type.K4_2]
	var ghosts = [Tower.Type.G1_1, Tower.Type.G1_2, Tower.Type.G2_1, Tower.Type.G2_2, Tower.Type.G3_1, Tower.Type.G3_2, Tower.Type.G4_1, Tower.Type.G4_2]
	var pumpkins = [Tower.Type.P1_1, Tower.Type.P1_2, Tower.Type.P2_1, Tower.Type.P2_2, Tower.Type.P3_1, Tower.Type.P3_2, Tower.Type.P4_1, Tower.Type.P4_2]
	var others = [Tower.Type.COIN, Tower.Type.ROCK, Tower.Type.BOMB, Tower.Type.MIRROR]
	for i in range(8):
		spider_slots.get_child(i).set_tower(Tower.new(spiders[i]), 0)
		skeleton_slots.get_child(i).set_tower(Tower.new(skeletons[i]), 0)
		ghost_slots.get_child(i).set_tower(Tower.new(ghosts[i]), 0)
		pumpkin_slots.get_child(i).set_tower(Tower.new(pumpkins[i]), 0)
		if i < 4: other_slots.get_child(i).set_tower(Tower.new(others[i]), 0)
	
	update()
	shoot_timer.timeout.connect(fake_shoot)


func _process(_delta):
	if Input.is_action_just_pressed("up"):
		selected[1] = posmod(selected[1] - 1, 5)
		if selected[1] == 3: selected[0] *= 2
		if selected[1] == 4: selected[0] /= 2
		update()
	elif Input.is_action_just_pressed("down"):
		selected[1] = posmod(selected[1] + 1, 5)
		if selected[1] == 0: selected[0] *= 2
		if selected[1] == 4: selected[0] /= 2
		update()
	if Input.is_action_just_pressed("left"):
		selected[0] = posmod(selected[0] - 1, 8)
		if selected[1] == 4 and selected[0] > 3: selected[0] = 3
		update()
	elif Input.is_action_just_pressed("right"):
		selected[0] = posmod(selected[0] + 1, 8)
		if selected[1] == 4 and selected[0] > 3: selected[0] = 0
		update()
	
	var slot: Slot = selected_slot()
	cursor.position = slot.global_position + Vector2(11, 14)
	
	if Input.is_action_just_pressed("b"):
		Util.hide_collection.emit()


func update():
	for i in range(8):
		set_active(spider_slots.get_child(i), selected == [i, 0])
		set_active(skeleton_slots.get_child(i), selected == [i, 1])
		set_active(ghost_slots.get_child(i), selected == [i, 2])
		set_active(pumpkin_slots.get_child(i), selected == [i, 3])
		if i < 4: set_active(other_slots.get_child(i), selected == [i, 4])
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(slots, "position", Vector2(get_scroll_x(), 24), 0.35)


func get_scroll_x() -> int:
	var x = selected[0] * (1 if selected[1] != 4 else 2)
	if x < 2: return 16
	return 16 - 32 * (x - 1)


func set_active(slot: Slot, active: bool) -> void:
	slot.state = Slot.State.Active if active else Slot.State.Idle
	slot.tower_node.show_popup(active, true)


func selected_slot() -> Slot:
	var all_slots: Array[Node2D] = [spider_slots, skeleton_slots, ghost_slots, pumpkin_slots, other_slots]
	return all_slots[selected[1]].get_child(selected[0])


func fake_shoot() -> void:
	var tower: Tower = selected_slot().tower_node.tower
	if tower.type in [Tower.Type.COIN, Tower.Type.ROCK, Tower.Type.BOMB, Tower.Type.MIRROR]: return
	FightUtil.tower_shoot.emit(tower, 0)
