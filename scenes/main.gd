extends Node2D

@onready var color_rect = $CanvasLayer/ColorRect
@onready var scene = $Scene
@onready var overlay = $Overlay

var shop_scene: PackedScene =       preload("res://scenes/shop/shop.tscn")
var fight_scene: PackedScene =      preload("res://scenes/fight/fight.tscn")
var collection_scene: PackedScene = preload("res://scenes/collection/collection.tscn")
var game_over_scene: PackedScene =  preload("res://scenes/game_over/game_over.tscn")


func _ready():
	Util.show_collection.connect(_on_show_collection)
	Util.hide_collection.connect(_on_hide_collection)
	Util.fight.connect(_on_fight)
	Util.game_over.connect(_on_game_over)
	Util.restart.connect(_on_restart)
	FightUtil.fight_end.connect(_on_fight_end)
	Palette.set_palette.connect(_on_set_palette)
	Palette.set_palette.emit(Palette.Name.NEXUS_2060)
	start_game()


func start_game():
	Progress.reset()
	Util.state = Util.GameState.Shop
	FighterData.reset()
	scene.add_child(shop_scene.instantiate())


func _on_fight() -> void:
	Util.state = Util.GameState.Fight
	scene.get_child(0).queue_free()
	scene.add_child(fight_scene.instantiate())


func _on_fight_end() -> void:
	Util.state = Util.GameState.Shop
	
	Progress.turn += 1
	Progress.heal_board()
	
	scene.get_child(0).queue_free()
	scene.add_child(shop_scene.instantiate())


func _on_game_over() -> void:
	Util.state = Util.GameState.GameOver
	scene.get_child(0).queue_free()
	scene.add_child(game_over_scene.instantiate())


func _on_restart() -> void:
	scene.get_child(0).queue_free()
	start_game()


func _on_show_collection() -> void:
	Util.state = Util.GameState.Collection
	overlay.add_child(collection_scene.instantiate())


func _on_hide_collection() -> void:
	Util.state = Util.GameState.Shop
	overlay.get_child(0).queue_free()


func _on_set_palette(p: Palette.Name) -> void:
	var m: ShaderMaterial = color_rect.material as ShaderMaterial
	var pal = Palette.get_palette(p)
	m.set_shader_parameter("c1", pal[0])
	m.set_shader_parameter("c2", pal[1])
	m.set_shader_parameter("c3", pal[2])
	m.set_shader_parameter("c4", pal[3])
