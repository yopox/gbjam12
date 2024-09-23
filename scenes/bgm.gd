class_name BGM extends AudioStreamPlayer

const BATTLE_1 = preload("res://music/Battle 1.ogg")
const BATTLE_2 = preload("res://music/Battle 2.ogg")
const BATTLE_3 = preload("res://music/Battle 3.ogg")
const BATTLE_4 = preload("res://music/Battle 4.ogg")
const BATTLE_5 = preload("res://music/Battle 5.ogg")
const COLLECTION = preload("res://music/Collection.ogg")
const LOSE = preload("res://music/Lose.ogg")
const SHOP_1 = preload("res://music/Shop 1.ogg")
const SHOP_2 = preload("res://music/Shop 2.ogg")
const SHOP_3 = preload("res://music/Shop 3.ogg")
const SHOP_4 = preload("res://music/Shop 4.ogg")
const SHOP_INTRO = preload("res://music/Shop intro.ogg")
const TRICK_OR_TREAT = preload("res://music/Trick or treat.ogg")
const WIN = preload("res://music/Win.ogg")

var mute: bool = false


func _ready():
	Util.mute.connect(_on_mute)


func _on_mute():
	mute = not mute
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute)


func _play_music(music: AudioStream, volume = -12):
	if stream == music:
		return
	stop()
	stream = music
	volume_db = volume
	play()
	

func play_bgm(state: Util.GameState):
	match state:
		Util.GameState.Collection, Util.GameState.Title, Util.GameState.EnterCode:
			_play_music(COLLECTION)
		Util.GameState.Shop:
			_play_music(SHOP_INTRO)
		Util.GameState.Fight:
			if Progress.turn in [1, 2, 3, 4, 5]:
				_play_music(BATTLE_1)
			elif Progress.turn in [6, 7, 8]:
				_play_music(BATTLE_2)
			elif Progress.turn in [9, 10, 11]:
				_play_music(BATTLE_3)
			elif Progress.turn in [12, 13, 14]:
				_play_music(BATTLE_3)
			else:
				_play_music(BATTLE_5)
		Util.GameState.GameOver:
			if Progress.enemy_dead:
				_play_music(WIN)
			else:
				_play_music(LOSE)
			
func _on_finished() -> void:
	if stream == SHOP_INTRO:
		match Progress.shop_level:
			1: _play_music(SHOP_1)
			2: _play_music(SHOP_2)
			3: _play_music(SHOP_3)
			4: _play_music(SHOP_4)
