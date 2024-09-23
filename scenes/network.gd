extends Node

@onready var request: HTTPRequest = $Get

const URL: String = "https://spider-rest.vercel.app"
const BOARD_VERSION: String = "1.0"


func _ready():
	FighterData.upload.connect(_on_upload)
	FighterData.get_board.connect(_on_get_board)
	FighterData.get_random_board.connect(_on_get_random_board)


func _on_get_request_completed(_result, _response_code, _headers, body: PackedByteArray):
	var response_data = body.get_string_from_utf8()
	var json = JSON.parse_string(response_data)
	
	if json == null or not json.has("request"): return
	
	match json["request"]:
		"board":
			if json["status"] == "OK":
				FighterData.board_uploaded.emit(true, str(int(json["count"])))
			else:
				FighterData.board_uploaded.emit(false, json["error"])
		"boards":
			if json["status"] == "OK":
				FighterData.board_retrieved.emit(true, json["boards"])
			else:
				FighterData.board_retrieved.emit(false, json["error"])
		"random":
			if json["status"] == "OK":
				FighterData.board_retrieved.emit(true, json["boards"])
			else:
				FighterData.board_retrieved.emit(false, json["error"])


func _on_upload(boards: String) -> void:
	var data: Dictionary = {}
	data["version"] = BOARD_VERSION
	data["boards"] = boards
	
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json; charset=utf-8"]
	
	request.request(URL + "/api/v1/board", headers, HTTPClient.METHOD_POST, json)


func _on_get_board(code: int) -> void:
	request.request(URL + "/api/v1/boards/" + str(code))


func _on_get_random_board() -> void:
	request.request(URL + "/api/v1/random")
