extends Node

enum Name { GRAYSCALE, YOPOX, NEXUS_2060, }

const WHITE = Color("ffffff")
const LIGHT_GRAY = Color("aaaaaa")
const DARK_GRAY = Color("666666")
const BLACK = Color("000000")

signal set_palette(p: Name)


func get_palette(p: Name) -> Array:
	match p:
		Name.YOPOX:
			return [Color("201e33"), Color("ab1a5d"), Color("ffbc43"), Color("ffffff")]
		Name.NEXUS_2060:
			return [Color("2a110c"), Color("f1461b"), Color("faad1f"), Color("fdfdfd")]
		_:
			return [Color("000000"), Color("555555"), Color("aaaaaa"), Color("ffffff")]
