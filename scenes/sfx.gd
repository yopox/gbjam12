class_name SFX extends Node

const GHOSTY = preload("res://music/fx/ghosty.ogg")
const PUMPKIN_DIE = preload("res://music/fx/pumpkin die.ogg")
const SELECTION = preload("res://music/fx/selection.ogg")
const SHOT = preload("res://music/fx/shot.ogg")
const SPAWN_CREATURES = preload("res://music/fx/spawn creatures.ogg")
const UPGRADE_UNLOCK = preload("res://music/fx/upgrade-unlock.ogg")

enum Sfx { Ghostly, Upgrade, Select, PumpkinHit, Shot, Spawn }


func _ready():
	Util.play_sfx.connect(_on_play_sfx)


func _play_sfx(sfx: AudioStream, volume = -6.0):
	var player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	player.stream = sfx
	player.volume_db = volume
	player.finished.connect(destroy_sfx.bind(player))
	add_child(player)
	player.play()


func destroy_sfx(audio: AudioStreamPlayer2D) -> void:
	audio.queue_free()


func _on_play_sfx(sfx: Sfx) -> void:
	match sfx:
		Sfx.Ghostly: _play_sfx(GHOSTY)
		Sfx.Upgrade: _play_sfx(UPGRADE_UNLOCK)
		Sfx.PumpkinHit: _play_sfx(PUMPKIN_DIE, -9)
		Sfx.Shot: _play_sfx(SHOT)
		Sfx.Select: _play_sfx(SELECTION)
		Sfx.Spawn: _play_sfx(SPAWN_CREATURES)
