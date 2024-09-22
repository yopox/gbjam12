class_name SFX extends AudioStreamPlayer


enum Sfx { Hit, Upgrade, Reroll, Select, Cancel, PumpkinHit, Arrow }


func _ready():
	Util.play_sfx.connect(_on_play_sfx)


func _on_play_sfx(sfx: Sfx) -> void:
	match sfx:
		Sfx.Hit: pass
		Sfx.Upgrade: pass
