## Author: DanielSpaten
## https://github.com/DanielSpaten/GodotCustomDataCompression
class_name BitWriter extends RefCounted
## This class writes Bits to a [PackedByteArray]
##
## Its supposed to be used in conjunction with the [BitReader],
## which allows for custom data compression

## The reset position of the bit-pointer
const POINTER_RESET: int = 7
## Caches the written bits
var _data: PackedInt32Array = []
## The current byte, that the Writer is writing to
var _byte: int

## The pointer inside of the currently used byte
var _bit_pointer: int = POINTER_RESET:
	set(value):
		if value < 0:
			_write_to_new_byte()
		else:
			_bit_pointer = value


## saves the written byte to the cached-data
func _write_to_new_byte() -> void:
	_data.append(_byte)
	_byte = 0
	_bit_pointer = POINTER_RESET


## Writes one bit to the Byte-Array
func write_bit(value: int) -> void:
	_byte |= (value << _bit_pointer)
	_bit_pointer -= 1
	

## Writes the 'bits'-many bits of an integer to the Byte-Array
func write_int(value: int, bits: int) -> void:
	for bit in bits:
		write_bit(value & (1 << bit) != 0)


## Returns the Byte-Array with the written bits inside of it. [br]
## This also clears the current data, so you can start with an empty byte-array again
func get_byte_array() -> PackedByteArray:
	if _bit_pointer != POINTER_RESET:
		_write_to_new_byte()

	var byteArray: PackedByteArray = []
	byteArray.resize(_data.size())
	for i: int in _data.size():
		byteArray.encode_s8(i, _data[i])
	_data.clear()

	return byteArray
