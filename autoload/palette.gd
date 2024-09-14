extends Node

enum Palettes { GRAYSCALE, YOPOX, }

const WHITE = Color("ffffff")
const LIGHT_GRAY = Color("aaaaaa")
const DARK_GRAY = Color("666666")
const BLACK = Color("000000")


func get_palette(p: Palettes) -> Array:
	match p:
		Palettes.YOPOX:
			return [Color("201e33"), Color("ab1a5d"), Color("ffbc43"), Color("808a94")]
		_:
			return [Color("000000"), Color("666666"), Color("aaaaaa"), WHITE]
