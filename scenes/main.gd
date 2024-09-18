extends Node2D

@onready var color_rect = $CanvasLayer/ColorRect
@onready var scene = $Scene

var shop_scene = preload("res://scenes/shop/shop.tscn")
var fight_scene = preload("res://scenes/fight/fight.tscn")


func _ready():
	var m = color_rect.material as ShaderMaterial
	var p = Palette.get_palette(Palette.Palettes.NEXUS_2060)
	m.set_shader_parameter("c1", p[0])
	m.set_shader_parameter("c2", p[1])
	m.set_shader_parameter("c3", p[2])
	m.set_shader_parameter("c4", p[3])

	scene.add_child(shop_scene.instantiate())
