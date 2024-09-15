extends Node

enum Palettes { GRAYSCALE, YOPOX, NEXUS_2060, }

const WHITE = Color("ffffff")
const LIGHT_GRAY = Color("aaaaaa")
const DARK_GRAY = Color("666666")
const BLACK = Color("000000")


func get_palette(p: Palettes) -> Array:
	match p:
		Palettes.YOPOX:
			return [Color("201e33"), Color("ab1a5d"), Color("ffbc43"), Color("808a94")]
		Palettes.NEXUS_2060:
			return [Color("2a110c"), Color("f1461b"), Color("faad1f"), Color("fdfdfd")]
		_:
			return [Color("000000"), Color("555555"), Color("aaaaaa"), Color("ffffff")]
