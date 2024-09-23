extends Node2D

@export var icons: Array[Sprite2D] = []


func _ready():
	for s: Sprite2D in icons:
		s.texture = s.texture.duplicate()


func show_code(i: int) -> void:
	var i2 = i
	for n in range(6):
		var k = i2 & 3
		i2 = i2 >> 2
		icons[n].texture.region.position.x = k * 16
