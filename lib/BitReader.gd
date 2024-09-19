## Author: DanielSpaten
## https://github.com/DanielSpaten/GodotCustomDataCompression
class_name BitReader extends RefCounted
## This class reads Bits from a [PackedByteArray]
##
## Its supposed to be used in conjunction with the [BitWriter],
## which allows for custom data compression

## The reset position of the bit-pointer
const POINTER_RESET: int = 7
## The byte-array the Reader reads from
var _data: PackedByteArray
## The current byte thats being read
var _byte: int
## Points to the currently read byte inside the byte-array
var _byte_pointer: int = 0

## Points to the current bit the reader is reading
var _bit_pointer: int = POINTER_RESET:
	set(value):
		if value < 0:
			_cache_new_byte()
		else:
			_bit_pointer = value


## Set the byte-array thats supposed to be read
func set_byte_array(data: PackedByteArray) -> void:
	_data = data
	_byte_pointer = 0
	_cache_new_byte()


## Loads a new byte from the byte-array
func _cache_new_byte() -> void:
	if _byte_pointer >= _data.size():
		return
	_byte = _data.decode_u8(_byte_pointer)
	_byte_pointer += 1
	_bit_pointer = POINTER_RESET


## Reads an integer with the given amount of bits from the byte-array
func read_int(bits: int) -> int:
	var value: int = 0
	for bit in bits:
		var bitValue = (_byte & (1 << _bit_pointer)) >> _bit_pointer
		value |= (bitValue << bit)
		_bit_pointer -= 1
	return value
