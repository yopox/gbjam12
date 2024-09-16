class_name TowerPopup extends Control

@onready var tower_name = $MarginContainer/VBoxContainer/Name
@onready var tower_family = $MarginContainer/VBoxContainer/Family
@onready var trigger = $MarginContainer/VBoxContainer/Trigger
@onready var description = $MarginContainer/VBoxContainer/Description
@onready var sep_2 = $MarginContainer/VBoxContainer/Sep2
@onready var stats = $MarginContainer/VBoxContainer/Stats


func set_tower(tower: Tower) -> void:
	tower_name.text = Text.tower_name(tower.type)
	
	var family_text = ""
	var families = FightUtil.tower_families(tower.type)
	for c in families:
		if not family_text.is_empty(): family_text += "/"
		family_text += Text.family_name(c)
	if families.is_empty(): family_text = Text.family_name(null)
	tower_family.text = family_text
	
	var trigger_text = Text.tower_trigger(tower.type)
	trigger.visible = not trigger_text.is_empty()
	trigger.text = "%s:" % trigger_text
	
	var desc = Text.tower_effect(tower.type)
	description.visible = not desc.is_empty()
	description.text = desc
	
	sep_2.visible = not trigger_text.is_empty() or not desc.is_empty()
	stats.text = "%s ATK / %s HP" % [tower.ATK, tower.HP]
