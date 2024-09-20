class_name Shop extends Node2D

@onready var level_label = $Header/Level
@onready var coins_label = $Header/Coins
@onready var slots = $Content/Slots
@onready var board: Board = $Board
@onready var cursor: Node2D = $Cursor
@onready var status_label: Label = $Status
@onready var fight_label: Label = $Fight
@onready var collection_label: Label = $Collection
@onready var sell_label: Label = $Sell

enum State { Select, Move, Buy, SelectColumn, SelectRow }

var state: State = State.Select: set = _set_state
var coins: int = 1: set = _set_coins
var focused: Array[int] = [1, 2]
var selected_slot: Slot = null
var just_bought: bool = false


func _ready():
	board.set_towers(Progress.player_board, false, 0)
	board.lock(Progress.turn)
	
	coins = min(Progress.turn, 8) + Progress.coin_bonus
	Progress.coin_bonus = 0

	for s: Slot in slots.get_children():
		s.set_tower(null, 1)
	slots.get_child(0).locked = Progress.shop_l_locked
	slots.get_child(3).locked = Progress.shop_r_locked
	reroll(true)
	
	update_cursor()
	update_status()
	update_header()
	update_labels()


func _process(_delta):
	if Util.state != Util.GameState.Shop: return
	
	if Input.is_action_just_pressed("up"):
		focused[1] = posmod(focused[1] - 1, 5)
		if focused[1] == 3: focused[0] *= 2
		if state == State.Move and focused[1] == 1: focused[1] = 3
		elif state == State.Buy and focused[1] in [0, 1]: focused[1] = 3
		elif focused[1] == 0: focused[0] /= 2
		update_cursor()
	elif Input.is_action_just_pressed("down"):
		focused[1] = posmod(focused[1] + 1, 5)
		if focused[1] == 1: focused[0] *= 2
		if state == State.Move and focused[1] == 0: focused[1] = 2
		elif state == State.Buy and focused[1] == 4: focused[1] = 2
		elif focused[1] == 4: focused[0] /= 2
		update_cursor()
	if Input.is_action_just_pressed("left"):
		focused[0] = posmod(focused[0] - 1, 4)
		if focused[1] in [0, 4] and focused[0] > 1: focused[0] = 0
		update_cursor()
	elif Input.is_action_just_pressed("right"):
		focused[0] = posmod(focused[0] + 1, 4)
		if focused[1] in [0, 4] and focused[0] > 1: focused[0] = 0
		update_cursor()
	
	if focused[1] == 4 and state == State.Move: focused[0] = 0
	
	if Input.is_action_just_pressed("a"):
		a()
		update_status()
	elif Input.is_action_just_pressed("b"):
		b()


func _set_state(value: State) -> void:
	state = value
	update_labels()
	

func _set_coins(value: int) -> void:
	coins = value
	update_header()


func a() -> void:
	if focused[1] == 0:
		if focused[0] == 0: reroll(false)
		if focused[0] == 1: upgrade()
		return
	
	if focused[1] == 4:
		if state == State.Move: sell()
		elif state == State.Select:
			if focused[0] == 0: fight()
			if focused[0] == 1: collection()
		return
		
	var slot: Slot = hovered_slot()
	if focused[1] == 1:
		if state == State.Select and slot.locked:
			var cost: int = Values.UNLOCK_COST
			if coins < cost:
				# TODO: Not enough coins animation
				pass
			else:
				coins -= cost
				if focused[0] == 0: Progress.shop_l_locked = false
				if focused[0] == 3: Progress.shop_r_locked = false
				slot.locked = false
				var drafted = draft(1)
				slot.set_tower(Tower.new(drafted[0]), 0)
				update_slots()
				update_status()
				return
		elif state == State.Select and not slot.locked and slot.tower_node.tower != null:
			var cost: int = FightUtil.tower_level(slot.tower_node.tower.type)
			if coins < cost:
				# TODO: Not enough coins animation
				pass
			else:
				state = State.Buy
				focused[1] = 2
				selected_slot = slot
				update_cursor()
				update_status()
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
			sync_board()
			TowerEffects.tower_moved()
			selected_slot = null
			state = State.Select
			update_slots()
		elif state == State.Buy and not slot.locked and slot.tower_node.tower == null:
			# Actually buy the tower
			var cost: int = FightUtil.tower_level(selected_slot.tower_node.tower.type)
			coins -= cost
			update_header()
			just_bought = true
			# Place the tower
			var t1: Variant = selected_slot.tower_node.tower
			slot.set_tower(t1, 0)
			selected_slot.set_tower(null, 0)
			sync_board()
			TowerEffects.tower_built(t1)
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
	if focused[1] == 4 and state == State.Move: pos.x = 78
	var y_pos: Array[int] = [34, 55, 84, 108, 138]
	pos.y = y_pos[focused[1]]
	cursor.position = pos
	just_bought = false
	
	update_slots()
	update_status()


func update_labels() -> void:
	sell_label.visible = state == State.Move
	fight_label.visible = state == State.Select
	collection_label.visible = state == State.Select


func update_slots() -> void:
	for s: Slot in board.get_children(): update_slot(s, -2)
	for s: Slot in slots.get_children(): update_slot(s, 0)


func update_slot(slot: Slot, dy: int) -> void:
	var selected: bool = slot == selected_slot
	var active: bool = (slot.row == focused[1] + dy and slot.column == focused[0])
	slot.state = Slot.State.Active if active or selected else Slot.State.Idle
	slot.update_rect()
	slot.tower_node.show_popup(not just_bought and active, false)


func update_header() -> void:
	level_label.text = "Level %s" % Progress.shop_level
	coins_label.text = "%s¢" % coins


func update_status() -> void:
	var slot: Slot = hovered_slot()

	if slot != null and slot.locked and focused[1] == 1:
		status_label.text = "Unlock for %s¢" % Values.UNLOCK_COST
		return
	elif slot != null and slot.locked:
		var countdown = Values.LOCKS[(focused[1] - 2) * 4 + focused[0]] - Progress.turn
		var turns = "turns" if countdown > 1 else "turn"
		status_label.text = "Unlocks in %s %s" % [countdown, turns]
		return
	elif state == State.Buy:
		status_label.text = "Select a slot"
		return
	elif state == State.Move and not focused[1] == 4:
		status_label.text = "Move to?"
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
	
	if focused[1] == 0:
		if focused[0] == 0: status_label.text = "Reroll for %s¢" % Values.REROLL_COST
		elif focused[0] == 1:
			if Progress.shop_level == Values.SHOP_LEVEL_MAX: status_label.text = "Level max"
			else: status_label.text = "Upgrade for %s¢" % Values.UPGRADE_COST[Progress.shop_level - 1]
	elif focused[1] == 4:
		if state == State.Move: status_label.text = "Sell for %s¢" % Values.SELL[FightUtil.tower_level(selected_slot.tower_node.tower.type) - 1]
		else:
			if focused[0] == 0: status_label.text = "Start the fight"
			elif focused[0] == 1: status_label.text = "View all creatures"


func reroll(free: bool) -> void:
	if not free:
		var cost: int = Values.REROLL_COST
		if coins < cost:
			# TODO: Not enough coins animation
			return
		coins -= cost
	var drafted = draft(4)
	for i in range(4):
		var slot: Slot = slots.get_child(i)
		if slot.locked: continue
		slot.set_tower(Tower.new(drafted[i]), 0)


func draft(nb: int) -> Array[Tower.Type]:
	var ranges: Array[Array] = Values.LEVEL_1_RANGES
	if Progress.shop_level == 2: ranges = Values.LEVEL_2_RANGES
	if Progress.shop_level == 3: ranges = Values.LEVEL_3_RANGES
	if Progress.shop_level == 4: ranges = Values.LEVEL_4_RANGES
	
	var drafted: Array[Tower.Type] = []
	for i in range(nb):
		var n: int = randi_range(0, 99)
		if ranges[0].has(n): drafted.append(Values.T1.pick_random())
		elif ranges[1].has(n): drafted.append(Values.T2.pick_random())
		elif ranges[2].has(n): drafted.append(Values.T3.pick_random())
		elif ranges[3].has(n): drafted.append(Values.T4.pick_random())
	
	return drafted


func upgrade() -> void:
	if Progress.shop_level == 4: return
	var cost: int = Values.UPGRADE_COST[Progress.shop_level - 1]
	if coins < cost:
		# TODO: Not enough coins animation
		return
	Progress.shop_level += 1
	coins -= cost


func fight() -> void:
	var export = Progress.export_board(Progress.player_board)
	print("Turn %s board: %s" % [Progress.turn, Progress.export_board(Progress.player_board)])
	#Progress.import_board(export)
	Util.fight.emit()


func collection() -> void:
	if state != State.Select: return
	Util.show_collection.emit()


func sell() -> void:
	coins += Values.SELL[FightUtil.tower_level(selected_slot.tower_node.tower.type) - 1]
	selected_slot.set_tower(null, 0)
	selected_slot = null
	state = State.Select
	sync_board()
	update_labels()
	update_slots()
	update_cursor()


func sync_board() -> void:
	Progress.player_board.clear()
	for i in range(8):
		var slot: Slot = board.get_child(i)
		if slot.tower_node.tower != null:
			Progress.player_board[i] = slot.tower_node.tower
