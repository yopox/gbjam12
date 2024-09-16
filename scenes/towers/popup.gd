class_name TowerPopup extends Node2D

@onready var tower_name = $PanelContainer/MarginContainer/VBoxContainer/Name
@onready var tower_class = $PanelContainer/MarginContainer/VBoxContainer/Class
@onready var trigger = $PanelContainer/MarginContainer/VBoxContainer/Trigger
@onready var description = $PanelContainer/MarginContainer/VBoxContainer/Description
@onready var sep_2 = $PanelContainer/MarginContainer/VBoxContainer/Sep2
@onready var stats = $PanelContainer/MarginContainer/VBoxContainer/Stats


func set_tower(tower: Tower) -> void:
	tower_name.text = Text.tower_name(tower.type)
	var tr = Text.tower_trigger(tower.type)
	trigger.visible = not tr.is_empty()
	trigger.text = tr
	var desc = Text.tower_effect(tower.type)
	description.visible = not desc.is_empty()
	description.text = desc
	sep_2.visible = not tr.is_empty() or not desc.is_empty()
	stats.text = "%s ATK / %s HP" % [tower.ATK, tower.HP]
