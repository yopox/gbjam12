extends Node2D

@onready var color_rect = $CanvasLayer/ColorRect


func _ready():
	var m = color_rect.material as ShaderMaterial
	var p = Palette.get_palette(Palette.Palettes.NEXUS_2060)
	m.set_shader_parameter("c1", p[0])
	m.set_shader_parameter("c2", p[1])
	m.set_shader_parameter("c3", p[2])
	m.set_shader_parameter("c4", p[3])
