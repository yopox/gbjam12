class_name Shop extends Node2D

@onready var level_label = $Header/Level
@onready var coins_label = $Header/Coins
@onready var slots = $Content/Slots
@onready var board: Board = $Board
@onready var cursor: Node2D = $Cursor
@onready var status_label: Label = $Status

enum State { Select, Move, Buy, SelectColumn, SelectRow }

var state: State = State.Select
var coins: int = 3
var focused: Array[int] = [0, 1]
var selected_slot: Slot = null


func _ready():
	Util.state = Util.GameState.Shop
	board.set_towers(Progress.player_board, false, 0)
	for s: Slot in slots.get_children():
		s.set_tower(null, 1)
	slots.get_child(0).locked = Progress.shop_l_locked
	slots.get_child(3).locked = Progress.shop_r_locked
	update_cursor()
	update_status()
	update_header()
	reroll()


func _process(_delta):
	if Input.is_action_just_pressed("up"):
		focused[1] = posmod(focused[1] - 1, 5)
		if focused[1] == 3: focused[0] *= 2
		if focused[1] == 0: focused[0] /= 2
		update_cursor()
	elif Input.is_action_just_pressed("down"):
		focused[1] = posmod(focused[1] + 1, 5)
		if focused[1] == 1: focused[0] *= 2
		if focused[1] == 4: focused[0] /= 2
		update_cursor()
	if Input.is_action_just_pressed("left"):
		focused[0] = posmod(focused[0] - 1, 4)
		if focused[1] in [0, 4] and focused[0] > 1: focused[0] = 0
		update_cursor()
	elif Input.is_action_just_pressed("right"):
		focused[0] = posmod(focused[0] + 1, 4)
		if focused[1] in [0, 4] and focused[0] > 1: focused[0] = 0
		update_cursor()
	
	if Input.is_action_just_pressed("a"):
		a()
		update_status()
	elif Input.is_action_just_pressed("b"):
		b()


func a() -> void:
	if focused[1] == 0:
		if focused[0] == 0: reroll()
		if focused[0] == 1: upgrade()
		return
	
	if focused[1] == 4:
		if focused[0] == 0: fight()
		if focused[0] == 1: collection()
		return
		
	var slot: Slot = hovered_slot()
	if focused[1] == 1:
		if state == State.Select and not slot.locked and slot.tower_node.tower != null:
			var cost: int = FightUtil.tower_level(slot.tower_node.tower.type)
			if coins < cost:
				# TODO: Not enough coins animation
				pass
			else:
				state = State.Buy
				selected_slot = slot
			return

	if focused[1] in [2, 3]:
		if state == State.Select and not slot.locked and slot.tower_node.tower != null:
			selected_slot = slot
			state = State.Move
		elif state == State.Move and not slot.locked:
			var t1: Variant = selected_slot.tower_node.tower
			var t2: Variant = slot.tower_node.tower
			selected_slot.set_tower(t2, 0)
			slot.set_tower(t1, 0)
			selected_slot = null
			state = State.Select
			update_slots()
		elif state == State.Buy and not slot.locked and slot.tower_node.tower == null:
			# Actually buy the tower
			var cost: int = FightUtil.tower_level(selected_slot.tower_node.tower.type)
			coins -= cost
			update_header()
			# Place the tower
			var t1: Variant = selected_slot.tower_node.tower
			slot.set_tower(t1, 0)
			# TODO: On build effect
			selected_slot.set_tower(null, 0)
			selected_slot = null
			state = State.Select
			update_slots()
		return
				

func b() -> void:
	match state:
		State.Move, State.Buy:
			selected_slot = null
			state = State.Select
			update_slots()
			update_status()
		State.Select: return
		_: return
	

func hovered_slot() -> Slot:
	if focused[1] == 1:
		return slots.get_child(focused[0])
	if focused[1] in [2, 3]:
		return board.get_child(focused[0] + (focused[1] - 2) * 4)
	return null


func update_cursor() -> void:
	var pos: Vector2 = Vector2.ZERO
	if focused[1] == 0 or focused[1] == 4: pos.x = 48 + focused[0] * 64
	else: pos.x = 36 + focused[0] * 32
	var y_pos: Array[int] = [34, 55, 84, 108, 138]
	pos.y = y_pos[focused[1]]
	cursor.position = pos
	
	update_slots()
	update_status()


func update_slots() -> void:
	for s: Slot in board.get_children(): update_slot(s, -2)
	for s: Slot in slots.get_children(): update_slot(s, 0)


func update_slot(slot: Slot, dy: int) -> void:
	var selected: bool = slot == selected_slot
	var active: bool = (slot.row == focused[1] + dy and slot.column == focused[0])
	slot.state = Slot.State.Active if active or selected else Slot.State.Idle
	slot.update_rect()
	slot.tower_node.show_popup(active, false)


func update_header() -> void:
	level_label.text = "Level %s" % Progress.shop_level
	coins_label.text = "%s¢" % coins


func update_status() -> void:
	var slot: Slot = hovered_slot()
	
	if slot != null and slot.locked:
		status_label.text = "Locked"
		return
	elif state == State.Buy:
		status_label.text = "Select a slot"
		return
	elif slot != null and slot.tower_node.tower == null:
		status_label.text = "Empty"
		return
	elif slot != null and focused[1] == 1:
		status_label.text = "Buy for %s¢" % FightUtil.tower_level(slot.tower_node.tower.type)
		return
	elif slot != null and focused[1] in [2, 3]:
		status_label.text = "%s" % Text.tower_name(slot.tower_node.tower.type)
		return
	
	if state == State.Move:
		status_label.text = "Move to?"
		return
	
	status_label.text = "-"
	
	if focused[1] == 0:
		if focused[0] == 0: status_label.text = "Reroll (%s¢)" % Values.REROLL_COST
		elif focused[0] == 1: status_label.text = "Upgrade (%s¢)" % Values.UPGRADE_COST
	elif focused[1] == 4:
		if focused[0] == 0: status_label.text = "Start the fight"
		elif focused[0] == 1: status_label.text = "View all creatures"


func reroll() -> void:
	var ranges: Array[Array] = Values.LEVEL_1_RANGES
	if Progress.shop_level == 2: ranges = Values.LEVEL_2_RANGES
	if Progress.shop_level == 3: ranges = Values.LEVEL_3_RANGES
	if Progress.shop_level == 4: ranges = Values.LEVEL_4_RANGES
	
	var draft: Array[Tower.Type] = []
	for i in range(4):
		var n: int = randi_range(0, 99)
		if ranges[0].has(n): draft.append(Values.T1.pick_random())
		elif ranges[1].has(n): draft.append(Values.T2.pick_random())
		elif ranges[2].has(n): draft.append(Values.T3.pick_random())
		elif ranges[3].has(n): draft.append(Values.T4.pick_random())
	
	for i in range(4):
		var slot: Slot = slots.get_child(i)
		if slot.locked: continue
		slot.set_tower(Tower.new(draft[i]), 0)


func upgrade() -> void:
	pass


func fight() -> void:
	pass


func collection() -> void:
	pass
