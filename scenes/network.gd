extends Node

@onready var request: HTTPRequest = $Get

const URL: String = "https://spider-rest-11229jdkf-yopoxs-projects-16d827fe.vercel.app"
const BOARD_VERSION: String = "1.0"


func _on_get_request_completed(result, response_code, headers, body: PackedByteArray):
	var response_data = body.get_string_from_utf8()
	print(response_data)


func _on_upload(boards: String) -> void:
	var data: Dictionary = {}
	data["version"] = BOARD_VERSION
	data["boards"] = boards
	
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	request.request(URL + "api/v1/board", headers, HTTPClient.METHOD_POST, json)
